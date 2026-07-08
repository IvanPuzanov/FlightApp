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
            return state.mapState.defaultRegionCoordinate == nil
                ? [.data(.getDefaultRegionLocation)]
                : []
        case .onAirportSelect:
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
        case .onSearchStartEditing:
            if let largeDetent = state.flightListState.bottomSheetState.detents.first(where: { $0.id == .large }) {
                state.flightListState.bottomSheetState.currentDetent = largeDetent
            }
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
        case let .onSetup(cornerRadius, shadowOpacity, detents):
            state.flightListState.appearance = HomeState.FlightListState.Appearance(
                defaultCornerRadius: cornerRadius,
                currentCornerRadius: cornerRadius,
                defaultShadowOpacity: shadowOpacity,
                currentShadowOpacity: shadowOpacity,
                isMapButtonHidden: true
            )
            state.flightListState.bottomSheetState = HomeState.FlightListState.BottomSheetState(
                detents: detents,
                currentDetent: HomeState.FlightListState.BottomSheetDetent(
                    id: .compact,
                    height: 200
                )
            )
            return []
        case let .onBottomSheetHeightChange(progress):
            updateStateOnBottomSheetHeight(progress: progress, state: &state)
            return []
        case let .onDetentSet(height):
            let previousDetent = state.flightListState.bottomSheetState.currentDetent
            if let detent = state.flightListState.bottomSheetState.detents.first(where: { $0.height == height }),
               detent != previousDetent {
                state.flightListState.bottomSheetState.currentDetent = detent
            }
            return []
        case .onMapButtonTap:
            if let detent = state.flightListState.bottomSheetState.detents.first(where: { $0.id == .compact }) {
                state.flightListState.bottomSheetState.currentDetent = detent
            }
            return []
        }
    }

    private func reduceCommonEvent(
        _ event: HomeEvent.UIEvent.CommonEvent,
        state: inout HomeState
    ) -> [HomeEffect] {
        switch event {
        case .onViewDidLoad:
            return [.data(.loadFlights), .data(.loadAirports)]
        case let .onCalculateFlightListMaxHeight(maxHeight):
            let detents = state.flightListState.bottomSheetState.detents
            let newDetentHeight = maxHeight - 39
            let largeDetent = HomeState.FlightListState.BottomSheetDetent(id: .large, height: newDetentHeight)

            if detents.contains(where: { $0.id == .large && abs($0.height - newDetentHeight) < 0.5 }) {
                return []
            }

            state.flightListState.bottomSheetState.detents = detents + [largeDetent]
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

    // MARK: - Private flight list event handling

    private func updateStateOnBottomSheetHeight(progress: CGFloat, state: inout HomeState) {
        let bottomSheetProgress = max(0, (progress - 0.95) / (1 - 0.95))
        let cornerRadius = bottomSheetProgress > 0
            ? min(state.flightListState.appearance.defaultCornerRadius, 1 / bottomSheetProgress)
            : state.flightListState.appearance.defaultCornerRadius
        let shadowOpacity = Float((1 - bottomSheetProgress) / 10)
        let isMapButtonHidden = bottomSheetProgress != 1

        guard state.headerState.bottomSheetProgress != bottomSheetProgress
            || state.flightListState.appearance.currentCornerRadius != cornerRadius
            || state.flightListState.appearance.currentShadowOpacity != shadowOpacity
            || state.flightListState.appearance.isMapButtonHidden != isMapButtonHidden
        else { return }

        state.headerState.bottomSheetProgress = bottomSheetProgress
        state.flightListState.appearance.currentCornerRadius = cornerRadius
        state.flightListState.appearance.currentShadowOpacity = shadowOpacity
        state.flightListState.appearance.isMapButtonHidden = isMapButtonHidden
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
