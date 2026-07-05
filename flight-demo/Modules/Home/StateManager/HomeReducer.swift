//
//  HomeReducer.swift
//  flight-demo
//
//  Created by Ivan Puzanov on 28.06.2026.
//

import Foundation

protocol HomeReducerProtocol: AnyObject {
    func reduce(state: inout HomeState, event: HomeEvent) -> [HomeEffect]
}

final class HomeReducer: HomeReducerProtocol {

    // MARK: - Public

    func reduce(state: inout HomeState, event: HomeEvent) -> [HomeEffect] {
        switch event {
        case let .ui(uiEvent):
            return reduceUiEvent(uiEvent, state: &state)
        case let .data(dataEvent):
            return reduceDataEvent(dataEvent, state: &state)
        }
    }

    // MARK: - Private UI event handling

    private func reduceUiEvent(
        _ event: HomeEvent.UIEvent,
        state: inout HomeState
    ) -> [HomeEffect] {
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
        _ event: HomeEvent.UIEvent.MapEvent,
        state: inout HomeState
    ) -> [HomeEffect] {
        switch event {
        case .onMapDidLoad:
            return state.mapState.isDefaultRegionSet
                ? []
                : [.data(.getDefaultRegionLocation)]
        case .onDefaultRegionSet:
            state.mapState.isDefaultRegionSet = true
            return []
        }
    }

    private func reduceHeaderEvent(
        _ event: HomeEvent.UIEvent.HeaderEvent,
        state: inout HomeState
    ) -> [HomeEffect] {
        switch event {
        case .onFilterTap:
            return []
        case .onMoreTap:
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
        _ event: HomeEvent.UIEvent.FlightListEvent,
        state: inout HomeState
    ) -> [HomeEffect] {
        switch event {
        case let .onBottomSheetHeightChange(progress):
            updateStateOnBottomSheetHeight(progress: progress, state: &state)
            return []
        }
    }

    private func reduceCommonEvent(
        _ event: HomeEvent.UIEvent.CommonEvent,
        state: inout HomeState
    ) -> [HomeEffect] {
        switch event {
        case .onViewDidLoad:
            state.flightListState.appearance.bottomSheetDetents = [200]
            return [.data(.loadFlights)]
        case let .onCalculateFlightListMaxHeight(maxHeight):
            state.flightListState.appearance.bottomSheetDetents = [200, 520, maxHeight - 40]
            return []
        }
    }

    // MARK: - Private Data event handling

    private func reduceDataEvent(
        _ event: HomeEvent.DataEvent,
        state: inout HomeState
    ) -> [HomeEffect] {
        switch event {
        case let .onGetLocation(coordinate):
            state.mapState.defaultRegionCoordinate = coordinate
            return []
        case .onAirportsLoaded:
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

    // MARK: - Private flight list event handling

    private func updateStateOnBottomSheetHeight(progress: CGFloat, state: inout HomeState) {
        let bottomSheetProgress = max(0, (progress - 0.95) / (1 - 0.95))
        state.headerState.bottomSheetProgress = bottomSheetProgress
        state.flightListState.appearance.bottomSheetProgress = bottomSheetProgress
    }

    private func updateFlightListContentStateIfNeeded(state: inout HomeState.FlightListState) {
        let searchText = state.parameters.searchText?.lowercased() ?? ""
        let flights = state.parameters.flights

        let filteredFlights = searchText.isEmpty
            ? flights
            : flights.filter {
                $0.flightNumber.lowercased().contains(searchText)
                || $0.airline.lowercased().contains(searchText)
            }

        state.contentState = filteredFlights.isEmpty
            ? .status(.empty)
            : .content(filteredFlights)
    }
}
