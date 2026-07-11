//
//  SearchStoreTests.swift
//  flight-demoTests
//
//  Created by Ivan Puzanov on 10.07.2026.
//

import Combine
import XCTest
@testable import FlightDemoApp

final class SearchStoreTests: XCTestCase {

    // MARK: - Properties

    private var service: SearchServiceMock!
    private var moduleOutput: SearchModuleOutputMock!
    private var sut: SearchStore!

    // MARK: - Test setup

    override func setUp() {
        super.setUp()

        service = SearchServiceMock()
        moduleOutput = SearchModuleOutputMock()
        sut = SearchStore(
            reducer: SearchReducer(),
            effectHandlers: [
                DataEffectHandler(service: service),
                NavigationEffectHandler(moduleOutput: moduleOutput)
            ]
        )
    }

    // MARK: - Data flow

    // Verifies that onViewDidLoad loads flights into store state
    func test_dispatch_onViewDidLoad_loadsFlightsIntoState() async {
        // Arrange
        let flights = [Flight.fake(id: "flight-1", flightNumber: "SU100")]
        service.stubbedLoadFlightsResult = .success(flights)

        // Act
        sut.dispatch(event: .ui(.common(.onViewDidLoad)))

        let didUpdate = await Utils.waitUntil {
            self.sut.state.flightListState.parameters.flights == flights
        }

        // Assert
        XCTAssertTrue(didUpdate)
        XCTAssertTrue(service.invokedLoadFlights)
        XCTAssertEqual(service.invokedLoadFlightsCallsCount, 1)
        assertContentState(sut.state.flightListState.contentState, equals: flights)
    }

    // Verifies that onViewDidLoad loads airports into store state
    func test_dispatch_onViewDidLoad_loadsAirportsIntoState() async {
        // Arrange
        let airports = [Airport.fake(id: 1)]
        service.stubbedLoadAirportsResult = .success(airports)

        // Act
        sut.dispatch(event: .ui(.common(.onViewDidLoad)))

        let didUpdate = await Utils.waitUntil {
            self.sut.state.mapState.airports == airports
        }

        // Assert
        XCTAssertTrue(didUpdate)
        XCTAssertTrue(service.invokedLoadAirports)
        XCTAssertEqual(service.invokedLoadAirportsCallsCount, 1)
        XCTAssertEqual(sut.state.mapState.airports, airports)
    }

    // Verifies that failed flight loading updates store state to error
    func test_dispatch_onViewDidLoad_setsErrorStateWhenFlightsFail() async {
        // Arrange
        service.stubbedLoadFlightsResult = .failure(NSError(domain: "test", code: 1))

        // Act
        sut.dispatch(event: .ui(.common(.onViewDidLoad)))

        let didUpdate = await Utils.waitUntil {
            if case .status(.error) = self.sut.state.flightListState.contentState {
                return true
            }
            return false
        }

        // Assert
        XCTAssertTrue(didUpdate)
        XCTAssertTrue(sut.state.flightListState.parameters.flights.isEmpty)
    }

    // Verifies that onMapDidLoad requests location and stores the coordinate in state
    func test_dispatch_onMapDidLoad_storesCoordinateInState() async {
        // Arrange
        let coordinate = Coordinate.fake()
        service.stubbedGetDefaultLocationResult = Just(coordinate)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()

        // Act
        sut.dispatch(event: .ui(.map(.onMapDidLoad)))

        let didUpdate = await Utils.waitUntil {
            self.sut.state.mapState.defaultRegionCoordinate == coordinate
        }

        // Assert
        XCTAssertTrue(didUpdate)
        XCTAssertTrue(service.invokedGetDefaultLocation)
        XCTAssertEqual(service.invokedGetDefaultLocationCallsCount, 1)
        XCTAssertEqual(sut.state.mapState.defaultRegionCoordinate, coordinate)
    }

    // MARK: - Navigation flow

    // Verifies that onFlightTap triggers navigation output with selected flight
    func test_dispatch_onFlightTap_triggersNavigationOutput() async {
        // Arrange
        let selectedFlight = Flight.fake(id: "flight-1", flightNumber: "SU100")
        let detents = [
            SearchState.FlightListState.BottomSheetDetent(id: .compact, height: 200),
            SearchState.FlightListState.BottomSheetDetent(id: .large, height: 600)
        ]

        sut.state.flightListState.parameters.flights = [selectedFlight]
        sut.state.flightListState.bottomSheetState.detents = detents
        sut.state.flightListState.bottomSheetState.currentDetent = detents[1]

        // Act
        sut.dispatch(event: .ui(.flightList(.onFlightTap(id: "flight-1"))))

        let didNavigate = await Utils.waitUntil {
            self.moduleOutput.invokedModuleWantsToOpenFlightDetailsCallsCount == 1
        }

        // Assert
        XCTAssertTrue(didNavigate)
        XCTAssertTrue(moduleOutput.invokedModuleWantsToOpenFlightDetails)
        XCTAssertEqual(
            moduleOutput.invokedModuleWantsToOpenFlightDetailsParameters?.inputData,
            FlightDetailsInputData.fake(flight: selectedFlight)
        )
        XCTAssertEqual(sut.state.flightListState.bottomSheetState.currentDetent, detents[0])
    }
}

// MARK: - Helpers

private extension SearchStoreTests {

    func assertContentState(
        _ contentState: SearchState.FlightListState.ContentState,
        equals expectedFlights: [Flight],
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        guard case let .content(flights) = contentState else {
            XCTFail("Expected content state, got \(contentState)", file: file, line: line)
            return
        }
        XCTAssertEqual(flights, expectedFlights, file: file, line: line)
    }
}
