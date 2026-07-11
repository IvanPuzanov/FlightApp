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
    func test_fetchAirports_success_mapsResponseModelsToAirports() async throws {
        // Arrange
        remoteDataSource.stubbedFetchAirportsResult = .success([
            AirportResponseModel.fake(id: 1),
            AirportResponseModel.fake(id: 2)
        ])

        // Act
        let airports = try await sut.fetchAirports()

        // Assert
        XCTAssertTrue(remoteDataSource.invokedFetchAirports)
        XCTAssertEqual(remoteDataSource.invokedFetchAirportsCallsCount, 1)
        XCTAssertEqual(airports.count, 2)
        XCTAssertEqual(airports[0].id, 1)
        XCTAssertEqual(airports[0].iata, "SVO")
        XCTAssertEqual(airports[1].id, 2)
    }

    // Verifies that fetchAirports throws when remote data source returns failure
    func test_fetchAirports_remoteFailure_throwsError() async {
        // Arrange
        let expectedError = NSError(domain: "test", code: 1)
        remoteDataSource.stubbedFetchAirportsResult = .failure(expectedError)

        // Act
        do {
            _ = try await sut.fetchAirports()
            XCTFail("Expected fetchAirports to throw")
        } catch {
            // Assert
            XCTAssertEqual((error as NSError).code, expectedError.code)
            XCTAssertTrue(remoteDataSource.invokedFetchAirports)
            XCTAssertEqual(remoteDataSource.invokedFetchAirportsCallsCount, 1)
        }
    }

    // Verifies that fetchAirports propagates thrown errors from remote data source
    func test_fetchAirports_remoteThrows_propagatesError() async {
        // Arrange
        let expectedError = NSError(domain: "test", code: 2)
        remoteDataSource.stubbedFetchAirportsError = expectedError

        // Act
        do {
            _ = try await sut.fetchAirports()
            XCTFail("Expected fetchAirports to throw")
        } catch {
            // Assert
            XCTAssertEqual((error as NSError).code, expectedError.code)
            XCTAssertTrue(remoteDataSource.invokedFetchAirports)
            XCTAssertEqual(remoteDataSource.invokedFetchAirportsCallsCount, 1)
        }
    }

    // MARK: - Fetch flights

    // Verifies that fetchFlights maps remote response models to domain flights
    func test_fetchFlights_success_mapsResponseModelsToFlights() async throws {
        // Arrange
        remoteDataSource.stubbedFetchFlightsResult = .success([
            FlightResponseModel.fake(id: "flight-1", flightNumber: "SU100"),
            FlightResponseModel.fake(id: "flight-2", flightNumber: "DP200")
        ])

        // Act
        let flights = try await sut.fetchFlights()

        // Assert
        XCTAssertTrue(remoteDataSource.invokedFetchFlights)
        XCTAssertEqual(remoteDataSource.invokedFetchFlightsCallsCount, 1)
        XCTAssertEqual(flights.count, 2)
        XCTAssertEqual(flights[0].id, "flight-1")
        XCTAssertEqual(flights[0].flightNumber, "SU100")
        XCTAssertEqual(flights[1].id, "flight-2")
        XCTAssertEqual(flights[1].flightNumber, "DP200")
    }

    // Verifies that fetchFlights throws when remote data source returns failure
    func test_fetchFlights_remoteFailure_throwsError() async {
        // Arrange
        let expectedError = NSError(domain: "test", code: 3)
        remoteDataSource.stubbedFetchFlightsResult = .failure(expectedError)

        // Act
        do {
            _ = try await sut.fetchFlights()
            XCTFail("Expected fetchFlights to throw")
        } catch {
            // Assert
            XCTAssertEqual((error as NSError).code, expectedError.code)
            XCTAssertTrue(remoteDataSource.invokedFetchFlights)
            XCTAssertEqual(remoteDataSource.invokedFetchFlightsCallsCount, 1)
        }
    }

    // Verifies that fetchFlights propagates thrown errors from remote data source
    func test_fetchFlights_remoteThrows_propagatesError() async {
        // Arrange
        let expectedError = NSError(domain: "test", code: 4)
        remoteDataSource.stubbedFetchFlightsError = expectedError

        // Act
        do {
            _ = try await sut.fetchFlights()
            XCTFail("Expected fetchFlights to throw")
        } catch {
            // Assert
            XCTAssertEqual((error as NSError).code, expectedError.code)
            XCTAssertTrue(remoteDataSource.invokedFetchFlights)
            XCTAssertEqual(remoteDataSource.invokedFetchFlightsCallsCount, 1)
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
