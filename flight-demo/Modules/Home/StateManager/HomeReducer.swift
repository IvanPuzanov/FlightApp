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

    // MARK: - Private

    private func reduceUiEvent(_ event: HomeEvent.UIEvent, state: inout HomeState) -> [HomeEffect] {
        switch event {
        case .onViewDidLoad:
            return [.data(.loadData)]
        case .onMapFullyRendered:
            if state.mapState.currentLocation == nil {
                return [.ui(.moveMapToUserLocation)]
            } else {
                return []
            }
        }
    }

    private func reduceDataEvent(_ event: HomeEvent.DataEvent, state: inout HomeState) -> [HomeEffect] {
        switch event {
        case let .onGetUserLocation(userLocation):
            state.mapState.currentLocation = userLocation
        }

        return []
    }
}
