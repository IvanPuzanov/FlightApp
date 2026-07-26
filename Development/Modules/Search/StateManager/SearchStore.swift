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
    private let dataEffectHandler: SearchDataEffectHandlerProtocol
    private let navigationEffectHandler: NavigationEffectHandlerProtocol

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
        dataEffectHandler: SearchDataEffectHandlerProtocol,
        navigationEffectHandler: NavigationEffectHandlerProtocol
    ) {
        self.reducer = reducer
        self.dataEffectHandler = dataEffectHandler
        self.navigationEffectHandler = navigationEffectHandler
    }
}

// MARK: - SearchStoreProtocol

extension SearchStore: SearchStoreProtocol {

    func dispatch(event: SearchEvent) {
        let effects = reducer.reduce(state: &state, event: event)

        for effect in effects {
            Task { [self] in
                await self.handleEffect(effect)
            }
        }
    }

    @MainActor
    private func handleEffect(_ effect: SearchEffect) async {
        switch effect {
        case let .data(dataEffect):
            await dataEffectHandler.handle(dataEffect) { [weak self] event in
                Task { [weak self] in
                    await MainActor.run {
                        self?.dispatch(event: event)
                    }
                }
            }
        case let .navigation(navigationEffect):
            navigationEffectHandler.handle(navigationEffect) { [weak self] event in
                Task { [weak self] in
                    await MainActor.run {
                        self?.dispatch(event: event)
                    }
                }
            }
        }
    }
}
