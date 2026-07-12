//
//  SearchStore.swift
//  flight-demo
//
//  Created by Ivan Puzanov on 28.06.2026.
//

import Combine

@MainActor
protocol SearchStoreProtocol: AnyObject {
    var state: SearchState { get }
    var stateDidChange: ObservableObjectPublisher { get }

    func dispatch(event: SearchEvent)
}

final class SearchStore {

    // MARK: - Dependencies

    private let reducer: any SearchReducerProtocol
    private let effectHandlers: [EffectHandlerProtocol]

    // MARK: - Public properties

    var state: SearchState = .initial {
        didSet {
            stateDidChange.send()
        }
    }

    var stateDidChange = ObservableObjectPublisher()

    // MARK: - Initialization

    init(
        reducer: any SearchReducerProtocol,
        effectHandlers: [EffectHandlerProtocol]
    ) {
        self.reducer = reducer
        self.effectHandlers = effectHandlers
    }
}

// MARK: - SearchStoreProtocol

extension SearchStore: SearchStoreProtocol {

    func dispatch(event: SearchEvent) {
        let effects = reducer.reduce(state: &state, event: event)

        effectHandlers.forEach { effectHandler in
            effects.forEach { effect in
                Task { [weak self] in
                    await effectHandler.handle(effect) { event in
                        self?.dispatch(event: event)
                    }
                }
            }
        }
    }
}
