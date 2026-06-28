//
//  HomeStore.swift
//  flight-demo
//
//  Created by Ivan Puzanov on 28.06.2026.
//

import Foundation

protocol HomeStoreProtocol {
    var didDispatchEffect: ((HomeEffect) -> Void)? { get set }
    var didUpdateState: ((HomeState) -> Void)? { get set }

    func dispatch(event: HomeEvent)
}

final class HomeStore {

    // MARK: - Dependencies

    private let reducer: HomeReducerProtocol
    weak var presenter: HomePresenterProtocol?

    // MARK: - Properties

    private var state: HomeState = .initial {
        didSet {
            if oldValue != state {
                didUpdateState?(state)
            }
        }
    }

    var didDispatchEffect: ((HomeEffect) -> Void)?
    var didUpdateState: ((HomeState) -> Void)?

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
            didDispatchEffect?($0)
        }
    }
}
