//
//  DataEffectHandlerTests.swift
//  flight-demoTests
//
//  Created by Ivan Puzanov on 10.07.2026.
//

import Combine
import XCTest
@testable import FlightDemoApp

final class DataEffectHandlerTests: XCTestCase {

    // MARK: - Properties

    private var service: SearchServiceMock!
    private var sut: DataEffectHandler!

    // MARK: - Test setup

    override func setUp() {
        super.setUp()

        service = SearchServiceMock()
        sut = DataEffectHandler(service: service)
    }

    // MARK: - Load flights

    // Verifies that loadFlights dispatches onFlightsLoaded with service data
    func test_loadFlights_success_dispatchesOnFlightsLoaded() async {
        // Arrange
        let flights = [Flight.fake()]
        service.stubbedLoadFlightsResult = .success(flights)
        let expectation = expectation(description: "onFlightsLoaded")

        // Act
        await sut.handle(.data(.loadFlights)) { event in
            // Assert
            guard case let .data(.onFlightsLoaded(receivedFlights)) = event else {
                return XCTFail("Expected onFlightsLoaded, got \(event)")
            }
            XCTAssertEqual(receivedFlights, flights)
            expectation.fulfill()
        }

        await fulfillment(of: [expectation], timeout: 1)
        XCTAssertTrue(service.invokedLoadFlights)
        XCTAssertEqual(service.invokedLoadFlightsCallsCount, 1)
    }

    // Verifies that loadFlights dispatches onFlightsFailed when service fails
    func test_loadFlights_failure_dispatchesOnFlightsFailed() async {
        // Arrange
        service.stubbedLoadFlightsResult = .failure(NSError(domain: "test", code: 1))
        let expectation = expectation(description: "onFlightsFailed")

        // Act
        await sut.handle(.data(.loadFlights)) { event in
            // Assert
            guard case .data(.onFlightsFailed) = event else {
                return XCTFail("Expected onFlightsFailed, got \(event)")
            }
            expectation.fulfill()
        }

        await fulfillment(of: [expectation], timeout: 1)
        XCTAssertTrue(service.invokedLoadFlights)
        XCTAssertEqual(service.invokedLoadFlightsCallsCount, 1)
    }

    // MARK: - Load airports

    // Verifies that loadAirports dispatches onAirportsLoaded with service data
    func test_loadAirports_success_dispatchesOnAirportsLoaded() async {
        // Arrange
        let airports = [Airport.fake()]
        service.stubbedLoadAirportsResult = .success(airports)
        let expectation = expectation(description: "onAirportsLoaded")

        // Act
        await sut.handle(.data(.loadAirports)) { event in
            // Assert
            guard case let .data(.onAirportsLoaded(receivedAirports)) = event else {
                return XCTFail("Expected onAirportsLoaded, got \(event)")
            }
            XCTAssertEqual(receivedAirports, airports)
            expectation.fulfill()
        }

        await fulfillment(of: [expectation], timeout: 1)
        XCTAssertTrue(service.invokedLoadAirports)
        XCTAssertEqual(service.invokedLoadAirportsCallsCount, 1)
    }

    // Verifies that loadAirports dispatches onAirportsFailed when service fails
    func test_loadAirports_failure_dispatchesOnAirportsFailed() async {
        // Arrange
        service.stubbedLoadAirportsResult = .failure(NSError(domain: "test", code: 1))
        let expectation = expectation(description: "onAirportsFailed")

        // Act
        await sut.handle(.data(.loadAirports)) { event in
            // Assert
            guard case .data(.onAirportsFailed) = event else {
                return XCTFail("Expected onAirportsFailed, got \(event)")
            }
            expectation.fulfill()
        }

        await fulfillment(of: [expectation], timeout: 1)
        XCTAssertTrue(service.invokedLoadAirports)
        XCTAssertEqual(service.invokedLoadAirportsCallsCount, 1)
    }

    // MARK: - Location

    // Verifies that getDefaultRegionLocation dispatches onGetLocation with coordinate
    func test_getDefaultRegionLocation_success_dispatchesOnGetLocation() async {
        // Arrange
        let coordinate = Coordinate.fake()
        service.stubbedGetDefaultLocationResult = Just(coordinate)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
        let expectation = expectation(description: "onGetLocation")

        // Act
        await sut.handle(.data(.getDefaultRegionLocation)) { event in
            // Assert
            guard case let .data(.onGetLocation(receivedCoordinate)) = event else {
                return XCTFail("Expected onGetLocation, got \(event)")
            }
            XCTAssertEqual(receivedCoordinate, coordinate)
            expectation.fulfill()
        }

        await fulfillment(of: [expectation], timeout: 1)
        XCTAssertTrue(service.invokedGetDefaultLocation)
        XCTAssertEqual(service.invokedGetDefaultLocationCallsCount, 1)
    }

    // Verifies that getDefaultRegionLocation dispatches onGetLocationFailed when service fails
    func test_getDefaultRegionLocation_failure_dispatchesOnGetLocationFailed() async {
        // Arrange
        service.stubbedGetDefaultLocationResult = Fail(error: NSError(domain: "test", code: 1))
            .eraseToAnyPublisher()
        let expectation = expectation(description: "onGetLocationFailed")

        // Act
        await sut.handle(.data(.getDefaultRegionLocation)) { event in
            // Assert
            guard case .data(.onGetLocationFailed) = event else {
                return XCTFail("Expected onGetLocationFailed, got \(event)")
            }
            expectation.fulfill()
        }

        await fulfillment(of: [expectation], timeout: 1)
        XCTAssertTrue(service.invokedGetDefaultLocation)
        XCTAssertEqual(service.invokedGetDefaultLocationCallsCount, 1)
    }

    // MARK: - Navigation

    // Verifies that navigation effects are ignored by the data effect handler
    func test_navigationEffect_doesNothing() async {
        // Arrange
        let flight = Flight.fake()
        let inputData = FlightDetailsInputData.fake(flight: flight)
        var completionCallCount = 0

        // Act
        await sut.handle(.navigation(.openFlightDetails(inputData: inputData))) { _ in
            completionCallCount += 1
        }

        // Assert
        XCTAssertEqual(completionCallCount, 0)
        XCTAssertFalse(service.invokedLoadFlights)
        XCTAssertFalse(service.invokedLoadAirports)
        XCTAssertFalse(service.invokedGetDefaultLocation)
    }
}
