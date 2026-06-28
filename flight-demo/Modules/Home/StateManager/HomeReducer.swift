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
        }
    }

    // MARK: - Private

    private func reduceUiEvent(_ event: HomeEvent.UIEvent, state: inout HomeState) -> [HomeEffect] {
        switch event {
        case .onViewDidLoad:
            return [.data(.loadData)]
        }
    }
}
