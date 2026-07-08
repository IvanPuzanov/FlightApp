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

    func dispatch(event: HomeEvent)
}

final class HomeStore {

    // MARK: - Dependencies

    private let reducer: HomeReducerProtocol
    private let effectHandlers: [EffectHandlerProtocol]

    // MARK: - Public properties

    var state: HomeState = .initial {
        didSet {
            stateDidChange.send()
        }
    }

    var stateDidChange = ObservableObjectPublisher()

    // MARK: - Initialization

    init(
        reducer: HomeReducerProtocol,
        effectHandlers: [EffectHandlerProtocol]
    ) {
        self.reducer = reducer
        self.effectHandlers = effectHandlers
    }
}

// MARK: - HomeStoreProtocol

extension HomeStore: HomeStoreProtocol {

    func dispatch(event: HomeEvent) {
        let effects = reducer.reduce(state: &state, event: event)

        effectHandlers.forEach { effectHandler in
            effects.forEach { effect in
                effectHandler.handle(effect) { event in
                    self.dispatch(event: event)
                }
            }
        }
    }
}
