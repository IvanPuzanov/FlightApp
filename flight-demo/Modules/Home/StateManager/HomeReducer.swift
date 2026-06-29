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
            state.bottomSheetState.detents = [
                .compact(120),
                .medium(380)
            ]
            return [.data(.loadData)]
        case .onMapDidLoad:
            return state.mapState.currentLocation == nil
                ? [.ui(.moveMapToDefaultRegion)]
                : []
        }
    }

    private func reduceDataEvent(_ event: HomeEvent.DataEvent, state: inout HomeState) -> [HomeEffect] {
        switch event {
        case let .onGetLocation(newLocation):
            state.mapState.currentLocation = newLocation
        }

        return []
    }
}
