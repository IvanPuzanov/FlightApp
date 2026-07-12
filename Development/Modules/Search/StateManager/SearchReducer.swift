//
//  SearchReducer.swift
//  flight-demo
//
//  Created by Ivan Puzanov on 28.06.2026.
//

import Foundation

protocol SearchReducerProtocol: ReducerProtocol {
    func reduce(state: inout SearchState, event: SearchEvent) -> [SearchEffect]
}

final class SearchReducer: SearchReducerProtocol {

    // MARK: - Public

    func reduce(state: inout SearchState, event: SearchEvent) -> [SearchEffect] {
        switch event {
        case let .ui(uiEvent):
            return reduceUiEvent(uiEvent, state: &state)
        case let .data(dataEvent):
            return reduceDataEvent(dataEvent, state: &state)
        }
    }

    // MARK: - Private UI event handling

    private func reduceUiEvent(
        _ event: SearchEvent.UIEvent,
        state: inout SearchState
    ) -> [SearchEffect] {
        switch event {
        case let .map(mapEvent):
            return reduceMapEvent(mapEvent, state: &state)
        case let .header(headerEvent):
            return reduceHeaderEvent(headerEvent, state: &state)
        case let .flightList(flightListEvent):
            return reduceFlightListEvent(flightListEvent, state: &state)
        case let .common(commonEvent):
            return reduceCommonEvent(commonEvent, state: &state)
        }
    }

    private func reduceMapEvent(
        _ event: SearchEvent.UIEvent.MapEvent,
        state: inout SearchState
    ) -> [SearchEffect] {
        switch event {
        case .onMapDidLoad:
            return state.mapState.defaultRegionCoordinate == nil
                ? [.data(.getDefaultRegionLocation)]
                : []
        case .onAirportSelect:
            return []
        }
    }

    private func reduceHeaderEvent(
        _ event: SearchEvent.UIEvent.HeaderEvent,
        state: inout SearchState
    ) -> [SearchEffect] {
        switch event {
        case .onFilterTap:
            return []
        case .onMoreTap:
            return []
        case .onSearchStartEditing:
            updateFlightListCurrentDetent(id: .large, state: &state.flightListState)
            return []
        case let .onSearchTextEnter(text):
            state.flightListState.parameters.searchText = text
            updateFlightListContentStateIfNeeded(state: &state.flightListState)
            return []
        case .onSearchTextEndEditing:
            state.headerState.mode = .search(text: state.flightListState.parameters.searchText)
            return []
        }
    }

    private func reduceFlightListEvent(
        _ event: SearchEvent.UIEvent.FlightListEvent,
        state: inout SearchState
    ) -> [SearchEffect] {
        switch event {
        case let .onSetup(cornerRadius, shadowOpacity, detents, currentDetent):
            state.flightListState.appearance = SearchState.FlightListState.Appearance(
                defaultCornerRadius: cornerRadius,
                currentCornerRadius: cornerRadius,
                defaultShadowOpacity: shadowOpacity,
                currentShadowOpacity: shadowOpacity,
                isMapButtonHidden: true
            )
            state.flightListState.bottomSheetState = SearchState.FlightListState.BottomSheetState(
                detents: detents,
                currentDetent: currentDetent
            )
            return []
        case let .onBottomSheetHeightChange(progress):
            updateStateOnBottomSheetHeight(progress: progress, state: &state)
            return []
        case let .onDetentSet(height):
            updateFlightListCurrentDetent(height: height, state: &state.flightListState)
            return []
        case let .onFlightTap(id):
            return handleOnFlightTap(id: id, state: &state.flightListState)
        case .onMapButtonTap:
            updateFlightListCurrentDetent(id: .compact, state: &state.flightListState)
            return []
        }
    }

    private func reduceCommonEvent(
        _ event: SearchEvent.UIEvent.CommonEvent,
        state: inout SearchState
    ) -> [SearchEffect] {
        switch event {
        case .onViewDidLoad:
            return [.data(.loadFlights), .data(.loadAirports)]
        case let .onCalculateFlightListMaxHeight(maxHeight):
            let detents = state.flightListState.bottomSheetState.detents
            let newDetentHeight = maxHeight - 39
            let largeDetent = SearchState.FlightListState.BottomSheetDetent(id: .large, height: newDetentHeight)

            state.flightListState.bottomSheetState.detents = detents + [largeDetent]
            return []
        }
    }

    // MARK: - Private Data event handling

    private func reduceDataEvent(
        _ event: SearchEvent.DataEvent,
        state: inout SearchState
    ) -> [SearchEffect] {
        switch event {
        case let .onGetLocation(coordinate):
            state.mapState.defaultRegionCoordinate = coordinate
            return []
        case .onGetLocationFailed:
            return []
        case let .onAirportsLoaded(airports):
            state.mapState.airports = airports
            return []
        case .onAirportsFailed:
            return []
        case let .onFlightsLoaded(flights):
            state.flightListState.parameters.flights = flights
            updateFlightListContentStateIfNeeded(state: &state.flightListState)
            return []
        case .onFlightsFailed:
            state.flightListState.parameters.flights = []
            state.flightListState.contentState = .status(.error)
            return []
        }
    }

    // MARK: - Private Flight List event handling

    private func updateStateOnBottomSheetHeight(progress: CGFloat, state: inout SearchState) {
        let bottomSheetProgress = max(0, (progress - 0.95) / (1 - 0.95))
        let cornerRadius = bottomSheetProgress > 0
            ? min(state.flightListState.appearance.defaultCornerRadius, 1 / bottomSheetProgress)
            : state.flightListState.appearance.defaultCornerRadius
        let shadowOpacity = Float((1 - bottomSheetProgress) / 10)
        let isMapButtonHidden = bottomSheetProgress != 1

        state.headerState.bottomSheetProgress = bottomSheetProgress
        state.flightListState.appearance.currentCornerRadius = cornerRadius
        state.flightListState.appearance.currentShadowOpacity = shadowOpacity
        state.flightListState.appearance.isMapButtonHidden = isMapButtonHidden
    }

    private func updateFlightListContentStateIfNeeded(state: inout SearchState.FlightListState) {
        let searchText = state.parameters.searchText?.lowercased() ?? ""
        let flights = state.parameters.flights

        let filteredFlights = searchText.isEmpty
            ? flights
            : flights.filter { $0.destination.city.lowercased().contains(searchText) }

        state.contentState = filteredFlights.isEmpty
            ? .status(.empty)
            : .content(filteredFlights)
    }

    private func handleOnFlightTap(id: String, state: inout SearchState.FlightListState) -> [SearchEffect] {
        guard let flight = state.parameters.flights.first(where: { $0.id == id }) else { return [] }

        updateFlightListCurrentDetent(id: .compact, state: &state)

        let inputData = FlightDetailsInputData(flight: flight)
        return [.navigation(.openFlightDetails(inputData: inputData))]
    }

    private func updateFlightListCurrentDetent(
        id: SearchState.FlightListState.BottomSheetDetentID,
        state: inout SearchState.FlightListState
    ) {
        guard let detent = state.bottomSheetState.detents.first(where: { $0.id == id }) else { return }

        state.bottomSheetState.currentDetent = detent
    }

    private func updateFlightListCurrentDetent(
        height: CGFloat,
        state: inout SearchState.FlightListState
    ) {
        guard let detent = state.bottomSheetState.detents.first(where: { $0.height == height }) else { return }

        state.bottomSheetState.currentDetent = detent
    }
}
