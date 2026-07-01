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
            state.flightListState.appearance.bottomSheetDetents = [120]
            return [.data(.loadFlights)]
        case let .onCalculateFlightListMaxHeight(maxHeight):
            state.flightListState.appearance.bottomSheetDetents = [120, maxHeight / 2, maxHeight]
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
        case .onAirportsLoaded:
            break
        case .onAirportsFailed:
            break
        case let .onFlightsLoaded(flights):
            state.flightListState.contentState = flights.isEmpty ? .status(.empty) : .status(.empty)
        case .onFlightsFailed:
            state.flightListState.contentState = .status(.error)
        }

        return []
    }

    // MARK: - Private flight list event handling

    private func updateStateOnBottomSheetHeight(progress: CGFloat, state: inout HomeState) {
        switch progress {
        case 0.9...1:
            let opacity = (progress - 0.9) / (1 - 0.9)
            state.headerState.progress = opacity
            state.flightListState.appearance.isGrabberHidden = true
        default:
            state.flightListState.appearance.isGrabberHidden = false
        }
    }
}
