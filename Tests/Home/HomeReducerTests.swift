//
//  HomeReducerTests.swift
//  flight-demoTests
//
//  Created by Ivan Puzanov on 08.07.2026.
//

import XCTest
@testable import FlightDemoApp

final class HomeReducerTests: XCTestCase {

    // MARK: - Properties

    private var sut: HomeReducer!
    private var state: HomeState!

    // MARK: - Test setup

    override func setUp() {
        super.setUp()

        sut = HomeReducer()
        state = HomeState.initial
    }

    // MARK: - Common events

    // Verifies that onViewDidLoad dispatches effects to load flights and airports
    func test_onViewDidLoad_dispatchesLoadDataEffects() {
        // Act
        let effects = sut.reduce(state: &state, event: .ui(.common(.onViewDidLoad)))

        // Assert
        XCTAssertEqual(effects, [.data(.loadFlights), .data(.loadAirports)])
        XCTAssertEqual(state, .initial)
    }

    // Verifies that onCalculateFlightListMaxHeight appends a large detent with the computed height
    func test_onCalculateFlightListMaxHeight_addsLargeDetent() {
        // Arrange
        state.flightListState.bottomSheetState.detents = [
            .init(id: .compact, height: 200)
        ]

        // Act
        let effects = sut.reduce(
            state: &state,
            event: .ui(.common(.onCalculateFlightListMaxHeight(839)))
        )

        // Assert
        XCTAssertTrue(effects.isEmpty)
        XCTAssertEqual(state.flightListState.bottomSheetState.detents.count, 2)
        XCTAssertEqual(
            state.flightListState.bottomSheetState.detents.last,
            .init(id: .large, height: 800)
        )
    }

    // MARK: - Map events

    // Verifies that onMapDidLoad without a coordinate requests the default region location
    func test_onMapDidLoad_withoutCoordinate_requestsDefaultRegionLocation() {
        // Act
        let effects = sut.reduce(state: &state, event: .ui(.map(.onMapDidLoad)))

        // Assert
        XCTAssertEqual(effects, [.data(.getDefaultRegionLocation)])
    }

    // Verifies that onMapDidLoad with an existing coordinate produces no effects
    func test_onMapDidLoad_withCoordinate_doesNotRequestLocation() {
        // Arrange
        state.mapState.defaultRegionCoordinate = Coordinate(latitude: 55.75, longitude: 37.62)

        // Act
        let effects = sut.reduce(state: &state, event: .ui(.map(.onMapDidLoad)))

        // Assert
        XCTAssertTrue(effects.isEmpty)
    }

    // Verifies that onAirportSelect does not change state or produce effects
    func test_onAirportSelect_doesNothing() {
        // Arrange
        let initialState = state

        // Act
        let effects = sut.reduce(state: &state, event: .ui(.map(.onAirportSelect(id: 42))))

        // Assert
        XCTAssertTrue(effects.isEmpty)
        XCTAssertEqual(state, initialState)
    }

    // MARK: - Header events

    // Verifies that onFilterTap does not change state
    func test_onFilterTap_doesNothing() {
        // Arrange
        let initialState = state

        // Act
        let effects = sut.reduce(state: &state, event: .ui(.header(.onFilterTap)))

        // Assert
        XCTAssertTrue(effects.isEmpty)
        XCTAssertEqual(state, initialState)
    }

    // Verifies that onMoreTap does not change state
    func test_onMoreTap_doesNothing() {
        // Arrange
        let initialState = state

        // Act
        let effects = sut.reduce(state: &state, event: .ui(.header(.onMoreTap)))

        // Assert
        XCTAssertTrue(effects.isEmpty)
        XCTAssertEqual(state, initialState)
    }

    // Verifies that onSearchStartEditing switches the bottom sheet to the large detent
    func test_onSearchStartEditing_setsLargeDetentWhenAvailable() {
        // Arrange
        let largeDetent = HomeState.FlightListState.BottomSheetDetent(id: .large, height: 600)
        state.flightListState.bottomSheetState.detents = [
            .init(id: .compact, height: 200),
            largeDetent
        ]
        state.flightListState.bottomSheetState.currentDetent = .init(id: .compact, height: 200)

        // Act
        let effects = sut.reduce(state: &state, event: .ui(.header(.onSearchStartEditing)))

        // Assert
        XCTAssertTrue(effects.isEmpty)
        XCTAssertEqual(state.flightListState.bottomSheetState.currentDetent, largeDetent)
    }

    // Verifies that onSearchStartEditing keeps the current detent when large is unavailable
    func test_onSearchStartEditing_keepsCurrentDetentWhenLargeIsMissing() {
        // Arrange
        let compactDetent = HomeState.FlightListState.BottomSheetDetent(id: .compact, height: 200)
        state.flightListState.bottomSheetState.detents = [compactDetent]
        state.flightListState.bottomSheetState.currentDetent = compactDetent

        // Act
        let effects = sut.reduce(state: &state, event: .ui(.header(.onSearchStartEditing)))

        // Assert
        XCTAssertTrue(effects.isEmpty)
        XCTAssertEqual(state.flightListState.bottomSheetState.currentDetent, compactDetent)
    }

    // Verifies that onSearchTextEnter stores the text and filters flights by flight number
    func test_onSearchTextEnter_filtersFlightsByFlightNumber() {
        // Arrange
        let matchingFlight = makeFlight(flightNumber: "SU100", airline: "Aeroflot")
        let otherFlight = makeFlight(flightNumber: "DP200", airline: "Pobeda")
        state.flightListState.parameters.flights = [matchingFlight, otherFlight]

        // Act
        let effects = sut.reduce(
            state: &state,
            event: .ui(.header(.onSearchTextEnter(text: "su1")))
        )

        // Assert
        XCTAssertTrue(effects.isEmpty)
        XCTAssertEqual(state.flightListState.parameters.searchText, "su1")
        assertContentState(state.flightListState.contentState, equals: [matchingFlight])
    }

    // Verifies that onSearchTextEnter filters flights by airline name
    func test_onSearchTextEnter_filtersFlightsByAirline() {
        // Arrange
        let matchingFlight = makeFlight(flightNumber: "SU100", airline: "Aeroflot")
        let otherFlight = makeFlight(flightNumber: "DP200", airline: "Pobeda")
        state.flightListState.parameters.flights = [matchingFlight, otherFlight]

        // Act
        let effects = sut.reduce(
            state: &state,
            event: .ui(.header(.onSearchTextEnter(text: "pobeda")))
        )

        // Assert
        XCTAssertTrue(effects.isEmpty)
        assertContentState(state.flightListState.contentState, equals: [otherFlight])
    }

    // Verifies that onSearchTextEnter with nil clears the filter and shows all flights
    func test_onSearchTextEnter_withNilShowsAllFlights() {
        // Arrange
        let flights = [
            makeFlight(flightNumber: "SU100"),
            makeFlight(flightNumber: "DP200")
        ]
        state.flightListState.parameters.flights = flights
        state.flightListState.parameters.searchText = "SU"

        // Act
        let effects = sut.reduce(
            state: &state,
            event: .ui(.header(.onSearchTextEnter(text: nil)))
        )

        // Assert
        XCTAssertTrue(effects.isEmpty)
        XCTAssertNil(state.flightListState.parameters.searchText)
        assertContentState(state.flightListState.contentState, equals: flights)
    }

    // Verifies that onSearchTextEnter with no matches sets the list to empty status
    func test_onSearchTextEnter_withNoMatches_setsEmptyStatus() {
        // Arrange
        state.flightListState.parameters.flights = [makeFlight(flightNumber: "SU100")]

        // Act
        let effects = sut.reduce(
            state: &state,
            event: .ui(.header(.onSearchTextEnter(text: "zzz")))
        )

        // Assert
        XCTAssertTrue(effects.isEmpty)
        assertContentStateIsEmpty(state.flightListState.contentState)
    }

    // Verifies that onSearchTextEndEditing switches the header to search mode with the current text
    func test_onSearchTextEndEditing_setsHeaderSearchMode() {
        // Arrange
        state.flightListState.parameters.searchText = "Aeroflot"

        // Act
        let effects = sut.reduce(state: &state, event: .ui(.header(.onSearchTextEndEditing)))

        // Assert
        XCTAssertTrue(effects.isEmpty)
        XCTAssertEqual(state.headerState.mode, .search(text: "Aeroflot"))
    }

    // MARK: - Flight list events

    // Verifies that onSetup configures appearance and the initial bottom sheet state
    func test_onSetup_configuresAppearanceAndBottomSheet() {
        // Arrange
        let detents = makeDetents()

        // Act
        let effects = sut.reduce(
            state: &state,
            event: .ui(.flightList(.onSetup(cornerRadius: 16, shadowOpacity: 0.5, detents: detents, currentDetent: detents.first!)))
        )

        // Assert
        XCTAssertTrue(effects.isEmpty)
        XCTAssertEqual(state.flightListState.appearance.defaultCornerRadius, 16)
        XCTAssertEqual(state.flightListState.appearance.currentCornerRadius, 16)
        XCTAssertEqual(state.flightListState.appearance.defaultShadowOpacity, 0.5)
        XCTAssertEqual(state.flightListState.appearance.currentShadowOpacity, 0.5)
        XCTAssertTrue(state.flightListState.appearance.isMapButtonHidden)
        XCTAssertEqual(state.flightListState.bottomSheetState.detents, detents)
        XCTAssertEqual(
            state.flightListState.bottomSheetState.currentDetent,
            .init(id: .compact, height: 200)
        )
    }

    // Verifies that onBottomSheetHeightChange at progress ≤ 0.95 keeps the sheet collapsed
    func test_onBottomSheetHeightChange_belowThreshold_keepsCollapsedAppearance() {
        // Arrange
        configureFlightListAppearance(cornerRadius: 16, shadowOpacity: 0.5)

        // Act
        let effects = sut.reduce(
            state: &state,
            event: .ui(.flightList(.onBottomSheetHeightChange(progress: 0.95)))
        )

        // Assert
        XCTAssertTrue(effects.isEmpty)
        XCTAssertEqual(state.headerState.bottomSheetProgress, 0)
        XCTAssertEqual(state.flightListState.appearance.currentCornerRadius, 16)
        XCTAssertEqual(state.flightListState.appearance.currentShadowOpacity, 0.1)
        XCTAssertTrue(state.flightListState.appearance.isMapButtonHidden)
    }

    // Verifies that onBottomSheetHeightChange at progress = 1 fully expands the bottom sheet
    func test_onBottomSheetHeightChange_atFullProgress_updatesAppearanceForExpandedSheet() {
        // Arrange
        configureFlightListAppearance(cornerRadius: 16, shadowOpacity: 0.5)

        // Act
        let effects = sut.reduce(
            state: &state,
            event: .ui(.flightList(.onBottomSheetHeightChange(progress: 1)))
        )

        // Assert
        XCTAssertTrue(effects.isEmpty)
        XCTAssertEqual(state.headerState.bottomSheetProgress, 1)
        XCTAssertEqual(state.flightListState.appearance.currentCornerRadius, 1)
        XCTAssertEqual(state.flightListState.appearance.currentShadowOpacity, 0)
        XCTAssertFalse(state.flightListState.appearance.isMapButtonHidden)
    }

    // Verifies that onBottomSheetHeightChange at intermediate progress interpolates appearance values
    func test_onBottomSheetHeightChange_atHalfProgress_interpolatesAppearance() {
        // Arrange
        configureFlightListAppearance(cornerRadius: 16, shadowOpacity: 0.5)

        // Act
        let effects = sut.reduce(
            state: &state,
            event: .ui(.flightList(.onBottomSheetHeightChange(progress: 0.975)))
        )

        // Assert
        XCTAssertTrue(effects.isEmpty)
        XCTAssertEqual(state.headerState.bottomSheetProgress, 0.5, accuracy: 0.001)
        XCTAssertEqual(state.flightListState.appearance.currentCornerRadius, 2, accuracy: 0.001)
        XCTAssertEqual(state.flightListState.appearance.currentShadowOpacity, 0.05, accuracy: 0.001)
        XCTAssertTrue(state.flightListState.appearance.isMapButtonHidden)
    }

    // Verifies that a repeated onBottomSheetHeightChange with the same values does not update state
    func test_onBottomSheetHeightChange_withSameValues_doesNotUpdateState() {
        // Arrange
        configureFlightListAppearance(cornerRadius: 16, shadowOpacity: 0.5)
        _ = sut.reduce(
            state: &state,
            event: .ui(.flightList(.onBottomSheetHeightChange(progress: 1)))
        )
        let stateAfterFirstChange = state

        // Act
        let effects = sut.reduce(
            state: &state,
            event: .ui(.flightList(.onBottomSheetHeightChange(progress: 1)))
        )

        // Assert
        XCTAssertTrue(effects.isEmpty)
        XCTAssertEqual(state, stateAfterFirstChange)
    }

    // Verifies that onDetentSet updates the current detent when the height matches
    func test_onDetentSet_updatesCurrentDetentWhenHeightMatches() {
        // Arrange
        let detents = makeDetents()
        state.flightListState.bottomSheetState.detents = detents
        state.flightListState.bottomSheetState.currentDetent = detents[0]

        // Act
        let effects = sut.reduce(
            state: &state,
            event: .ui(.flightList(.onDetentSet(400)))
        )

        // Assert
        XCTAssertTrue(effects.isEmpty)
        XCTAssertEqual(state.flightListState.bottomSheetState.currentDetent, detents[1])
    }

    // Verifies that onDetentSet with the same detent height does not change state
    func test_onDetentSet_withSameDetent_doesNotChangeState() {
        // Arrange
        let detents = makeDetents()
        state.flightListState.bottomSheetState.detents = detents
        state.flightListState.bottomSheetState.currentDetent = detents[1]
        let stateBefore = state

        // Act
        let effects = sut.reduce(
            state: &state,
            event: .ui(.flightList(.onDetentSet(400)))
        )

        // Assert
        XCTAssertTrue(effects.isEmpty)
        XCTAssertEqual(state, stateBefore)
    }

    // Verifies that onDetentSet with an unknown height does not change the current detent
    func test_onDetentSet_withUnknownHeight_doesNotChangeDetent() {
        // Arrange
        let detents = makeDetents()
        state.flightListState.bottomSheetState.detents = detents
        state.flightListState.bottomSheetState.currentDetent = detents[0]
        let stateBefore = state

        // Act
        let effects = sut.reduce(
            state: &state,
            event: .ui(.flightList(.onDetentSet(999)))
        )

        // Assert
        XCTAssertTrue(effects.isEmpty)
        XCTAssertEqual(state, stateBefore)
    }

    // Verifies that onMapButtonTap collapses the bottom sheet to the compact detent
    func test_onMapButtonTap_setsCompactDetent() {
        // Arrange
        let detents = makeDetents()
        state.flightListState.bottomSheetState.detents = detents
        state.flightListState.bottomSheetState.currentDetent = detents[2]

        // Act
        let effects = sut.reduce(state: &state, event: .ui(.flightList(.onMapButtonTap)))

        // Assert
        XCTAssertTrue(effects.isEmpty)
        XCTAssertEqual(state.flightListState.bottomSheetState.currentDetent, detents[0])
    }

    // Verifies that onMapButtonTap without a compact detent does not change state
    func test_onMapButtonTap_withoutCompactDetent_doesNotChangeState() {
        // Arrange
        let regularDetent = HomeState.FlightListState.BottomSheetDetent(id: .regular, height: 400)
        state.flightListState.bottomSheetState.detents = [regularDetent]
        state.flightListState.bottomSheetState.currentDetent = regularDetent
        let stateBefore = state

        // Act
        let effects = sut.reduce(state: &state, event: .ui(.flightList(.onMapButtonTap)))

        // Assert
        XCTAssertTrue(effects.isEmpty)
        XCTAssertEqual(state, stateBefore)
    }

    // MARK: - Data events

    // Verifies that onGetLocation stores the map region coordinate
    func test_onGetLocation_setsDefaultRegionCoordinate() {
        // Arrange
        let coordinate = Coordinate(latitude: 59.93, longitude: 30.31)

        // Act
        let effects = sut.reduce(state: &state, event: .data(.onGetLocation(coordinate)))

        // Assert
        XCTAssertTrue(effects.isEmpty)
        XCTAssertEqual(state.mapState.defaultRegionCoordinate, coordinate)
    }

    // Verifies that onGetLocationFailed does not change state
    func test_onGetLocationFailed_doesNothing() {
        // Arrange
        let initialState = state

        // Act
        let effects = sut.reduce(state: &state, event: .data(.onGetLocationFailed))

        // Assert
        XCTAssertTrue(effects.isEmpty)
        XCTAssertEqual(state, initialState)
    }

    // Verifies that onAirportsLoaded stores the airports list
    func test_onAirportsLoaded_setsAirports() {
        // Arrange
        let airports = [makeAirport(id: 1), makeAirport(id: 2)]

        // Act
        let effects = sut.reduce(state: &state, event: .data(.onAirportsLoaded(airports)))

        // Assert
        XCTAssertTrue(effects.isEmpty)
        XCTAssertEqual(state.mapState.airports, airports)
    }

    // Verifies that onAirportsFailed does not change state
    func test_onAirportsFailed_doesNothing() {
        // Arrange
        let initialState = state

        // Act
        let effects = sut.reduce(state: &state, event: .data(.onAirportsFailed))

        // Assert
        XCTAssertTrue(effects.isEmpty)
        XCTAssertEqual(state, initialState)
    }

    // Verifies that onFlightsLoaded stores flights and shows content
    func test_onFlightsLoaded_setsFlightsAndContentState() {
        // Arrange
        let flights = [makeFlight(flightNumber: "SU100"), makeFlight(flightNumber: "DP200")]

        // Act
        let effects = sut.reduce(state: &state, event: .data(.onFlightsLoaded(flights)))

        // Assert
        XCTAssertTrue(effects.isEmpty)
        XCTAssertEqual(state.flightListState.parameters.flights, flights)
        assertContentState(state.flightListState.contentState, equals: flights)
    }

    // Verifies that onFlightsLoaded applies an existing search filter
    func test_onFlightsLoaded_appliesExistingSearchFilter() {
        // Arrange
        state.flightListState.parameters.searchText = "DP"
        let flights = [makeFlight(flightNumber: "SU100"), makeFlight(flightNumber: "DP200")]

        // Act
        let effects = sut.reduce(state: &state, event: .data(.onFlightsLoaded(flights)))

        // Assert
        XCTAssertTrue(effects.isEmpty)
        assertContentState(
            state.flightListState.contentState,
            equals: [flights[1]]
        )
    }

    // Verifies that onFlightsLoaded with an empty list sets empty status
    func test_onFlightsLoaded_withEmptyList_setsEmptyStatus() {
        // Act
        let effects = sut.reduce(state: &state, event: .data(.onFlightsLoaded([])))

        // Assert
        XCTAssertTrue(effects.isEmpty)
        XCTAssertTrue(state.flightListState.parameters.flights.isEmpty)
        assertContentStateIsEmpty(state.flightListState.contentState)
    }

    // Verifies that onFlightsFailed clears flights and shows an error
    func test_onFlightsFailed_clearsFlightsAndSetsErrorStatus() {
        // Arrange
        state.flightListState.parameters.flights = [makeFlight()]

        // Act
        let effects = sut.reduce(state: &state, event: .data(.onFlightsFailed))

        // Assert
        XCTAssertTrue(effects.isEmpty)
        XCTAssertTrue(state.flightListState.parameters.flights.isEmpty)
        assertContentStateIsError(state.flightListState.contentState)
    }
}

// MARK: - Helpers

private extension HomeReducerTests {

    func makeFlight(
        flightNumber: String = "SU100",
        airline: String = "Aeroflot"
    ) -> Flight {
        Flight(
            from: FlightResponseModel(
                id: 1,
                flightNumber: flightNumber,
                airline: airline,
                airlineCode: "SU",
                aircraft: "A320",
                originCity: "Moscow",
                originIata: "SVO",
                destinationCity: "Saint Petersburg",
                destinationIata: "LED",
                status: .boarding
            )
        )
    }

    func makeAirport(id: Int) -> Airport {
        Airport(
            from: AirportResponseModel(
                id: id,
                iata: "SVO",
                city: "Moscow",
                country: "Russia",
                lat: 55.97,
                lon: 37.41
            )
        )
    }

    func makeDetents() -> [HomeState.FlightListState.BottomSheetDetent] {
        [
            .init(id: .compact, height: 200),
            .init(id: .regular, height: 400),
            .init(id: .large, height: 600)
        ]
    }

    func configureFlightListAppearance(cornerRadius: CGFloat, shadowOpacity: Float) {
        state.flightListState.appearance = HomeState.FlightListState.Appearance(
            defaultCornerRadius: cornerRadius,
            currentCornerRadius: cornerRadius,
            defaultShadowOpacity: shadowOpacity,
            currentShadowOpacity: shadowOpacity,
            isMapButtonHidden: true
        )
        state.headerState.bottomSheetProgress = 0
    }

    func assertContentState(
        _ contentState: HomeState.FlightListState.ContentState,
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

    func assertContentStateIsEmpty(
        _ contentState: HomeState.FlightListState.ContentState,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        guard case let .status(status) = contentState else {
            XCTFail("Expected status state, got \(contentState)", file: file, line: line)
            return
        }
        XCTAssertEqual(status, .empty, file: file, line: line)
    }

    func assertContentStateIsError(
        _ contentState: HomeState.FlightListState.ContentState,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        guard case let .status(status) = contentState else {
            XCTFail("Expected status state, got \(contentState)", file: file, line: line)
            return
        }
        XCTAssertEqual(status, .error, file: file, line: line)
    }
}
