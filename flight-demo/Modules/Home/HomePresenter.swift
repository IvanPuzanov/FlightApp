//
//  HomePresenter.swift
//  flight-demo
//
//  Created by Ivan Puzanov on 28.06.2026.
//

import Foundation

protocol HomePresenterProtocol: AnyObject {
    func dispatch(_ event: HomeEvent.UIEvent)
}

final class HomePresenter {

    // MARK: - Dependencies

    private var store: HomeStoreProtocol
    private let service: HomeServiceProtocol

    // MARK: - Initialization

    init(
        store: HomeStoreProtocol,
        service: HomeServiceProtocol
    ) {
        self.store = store
        self.service = service

        setupBinding()
    }

    // MARK: - Private

    private func setupBinding() {
        store.didDispatchEffect = { [weak self] effect in
            switch effect {
            case let .data(dataEffect):
                self?.handleDataEffect(dataEffect)
            default:
                return
            }
        }
    }

    private func handleDataEffect(_ effect: HomeEffect.DataEffect) {
        switch effect {
        case .loadData:
            service.loadData()
        }
    }
}

// MARK: - HomePresenterProtocol

extension HomePresenter: HomePresenterProtocol {

    func dispatch(_ event: HomeEvent.UIEvent) {
        store.dispatch(event: .ui(event))
    }
}
