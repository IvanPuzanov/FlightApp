//
//  HomePresenter.swift
//  flight-demo
//
//  Created by Ivan Puzanov on 28.06.2026.
//

import Foundation

protocol HomePresenterProtocol {
    func dispatch(_ event: HomeEvent)
}

final class HomePresenter {}

// MARK: - HomePresenterProtocol

extension HomePresenter: HomePresenterProtocol {

    func dispatch(_ event: HomeEvent) {
        switch event {
        case .onViewDidLoad:
            break
        }
    }
}
