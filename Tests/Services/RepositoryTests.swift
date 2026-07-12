//
//  RepositoryTests.swift
//  flight-demoTests
//
//  Created by Ivan Puzanov on 10.07.2026.
//

import XCTest
@testable import FlightDemoApp

final class RepositoryTests: XCTestCase {

    // MARK: - Properties

    private var remoteDataSource: RemoteDataSourceMock!
    private var locationService: LocationServiceMock!
    private var sut: Repository!

    // MARK: - Test setup

    override func setUp() {
        super.setUp()

        remoteDataSource = RemoteDataSourceMock()
        locationService = LocationServiceMock()
        sut = Repository(
            remoteDataSource: remoteDataSource,
            locationService: locationService
        )
    }

    // MARK: - Fetch airports

    // Verifies that fetchAirports maps remote response models to domain airports
    func test_fetchAirports_success_mapsResponseModelsToAirports() async {
        // Arrange
        remoteDataSource.stubbedFetchAirportsResult = .success([
            AirportResponseModel.fake(id: 1),
            AirportResponseModel.fake(id: 2)
        ])

        // Act
        let result = await sut.fetchAirports()

        // Assert
        XCTAssertTrue(remoteDataSource.invokedFetchAirports)
        XCTAssertEqual(remoteDataSource.invokedFetchAirportsCallsCount, 1)

        switch result {
        case let .success(airports):
            XCTAssertEqual(airports.count, 2)
            XCTAssertEqual(airports[0].id, 1)
            XCTAssertEqual(airports[0].iata, "SVO")
            XCTAssertEqual(airports[1].id, 2)
        case .failure:
            XCTFail("Expected successful airports result")
        }
    }

    // Verifies that fetchAirports returns failure when remote data source fails
    func test_fetchAirports_remoteFailure_returnsFailure() async {
        // Arrange
        let expectedError = NSError(domain: "test", code: 1)
        remoteDataSource.stubbedFetchAirportsResult = .failure(expectedError)

        // Act
        let result = await sut.fetchAirports()

        // Assert
        XCTAssertTrue(remoteDataSource.invokedFetchAirports)
        XCTAssertEqual(remoteDataSource.invokedFetchAirportsCallsCount, 1)

        switch result {
        case .success:
            XCTFail("Expected failure result")
        case let .failure(error):
            XCTAssertEqual((error as NSError).code, expectedError.code)
        }
    }

    // MARK: - Fetch flights

    // Verifies that fetchFlights maps remote response models to domain flights
    func test_fetchFlights_success_mapsResponseModelsToFlights() async {
        // Arrange
        remoteDataSource.stubbedFetchFlightsResult = .success([
            FlightResponseModel.fake(id: "flight-1", airlineName: "Aeroflot"),
            FlightResponseModel.fake(id: "flight-2", airlineName: "Pobeda")
        ])

        // Act
        let result = await sut.fetchFlights()

        // Assert
        XCTAssertTrue(remoteDataSource.invokedFetchFlights)
        XCTAssertEqual(remoteDataSource.invokedFetchFlightsCallsCount, 1)

        switch result {
        case let .success(flights):
            XCTAssertEqual(flights.count, 2)
            XCTAssertEqual(flights[0].id, "flight-1")
            XCTAssertEqual(flights[0].airline.name, "Aeroflot")
            XCTAssertEqual(flights[0].baggage.cabinBaggageKg, 8)
            XCTAssertEqual(flights[0].status, .regular)
            XCTAssertEqual(flights[1].id, "flight-2")
            XCTAssertEqual(flights[1].airline.name, "Pobeda")
        case .failure:
            XCTFail("Expected successful flights result")
        }
    }

    // Verifies that fetchFlights returns failure when remote data source fails
    func test_fetchFlights_remoteFailure_returnsFailure() async {
        // Arrange
        let expectedError = NSError(domain: "test", code: 3)
        remoteDataSource.stubbedFetchFlightsResult = .failure(expectedError)

        // Act
        let result = await sut.fetchFlights()

        // Assert
        XCTAssertTrue(remoteDataSource.invokedFetchFlights)
        XCTAssertEqual(remoteDataSource.invokedFetchFlightsCallsCount, 1)

        switch result {
        case .success:
            XCTFail("Expected failure result")
        case let .failure(error):
            XCTAssertEqual((error as NSError).code, expectedError.code)
        }
    }

    // MARK: - User location

    // Verifies that getUserLocation returns the default coordinate from location service
    func test_getUserLocation_returnsDefaultCoordinate() {
        // Arrange
        let expectedCoordinate = Coordinate.fake(latitude: 59.93, longitude: 30.31)
        locationService.stubbedGetDefaultLocationResult = expectedCoordinate
        let expectation = expectation(description: "getUserLocation")

        // Act
        sut.getUserLocation { result in
            // Assert
            switch result {
            case let .success(coordinate):
                XCTAssertEqual(coordinate, expectedCoordinate)
            case .failure:
                XCTFail("Expected successful location result")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)
        XCTAssertTrue(locationService.invokedGetDefaultLocation)
        XCTAssertEqual(locationService.invokedGetDefaultLocationCallsCount, 1)
    }
}
