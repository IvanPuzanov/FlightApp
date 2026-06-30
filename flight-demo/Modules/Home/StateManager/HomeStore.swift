//
//  HomeStore.swift
//  flight-demo
//
//  Created by Ivan Puzanov on 28.06.2026.
//

import Combine

protocol HomeStoreProtocol: AnyObject {
    var state: HomeState { get }
    var stateDidChange: ObservableObjectPublisher { get }
    var effectDidDispatch: PassthroughSubject<HomeEffect, Never> { get }

    func dispatch(event: HomeEvent)
}

final class HomeStore {

    // MARK: - Dependencies

    private let reducer: HomeReducerProtocol

    // MARK: - Public properties

    var state: HomeState = .initial {
        didSet {
            stateDidChange.send()
        }
    }

    var stateDidChange = ObservableObjectPublisher()
    var effectDidDispatch = PassthroughSubject<HomeEffect, Never>()

    // MARK: - Initialization

    init(reducer: HomeReducerProtocol) {
        self.reducer = reducer
    }
}

// MARK: - HomeStoreProtocol

extension HomeStore: HomeStoreProtocol {

    func dispatch(event: HomeEvent) {
        let effects = reducer.reduce(state: &state, event: event)
        effects.forEach {
            effectDidDispatch.send($0)
        }
    }
}
