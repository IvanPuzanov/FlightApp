//
//  HomePresenter.swift
//  flight-demo
//
//  Created by Ivan Puzanov on 28.06.2026.
//

import CoreLocation

protocol HomePresenterProtocol: AnyObject {
    func dispatch(_ event: HomeEvent.UIEvent)
}

final class HomePresenter {

    // MARK: - Dependencies

    weak var view: HomeViewControllerProtocol?

    private var store: HomeStoreProtocol
    private let service: HomeServiceProtocol
    private let locationManager: LocationManagerProtocol

    // MARK: - Initialization

    init(
        store: HomeStoreProtocol,
        service: HomeServiceProtocol,
        locationManager: LocationManagerProtocol
    ) {
        self.store = store
        self.service = service
        self.locationManager = locationManager

        setupBinding()
    }

    // MARK: - Private

    private func setupBinding() {
        store.didDispatchEffect = { [weak self] effect in
            guard let self else { return }

            switch effect {
            case let .data(dataEffect):
                self.handleDataEffect(dataEffect)
            case .ui(let uiEffect):
                self.handleUiEffect(uiEffect)
            }
        }

        store.didUpdateState = { [weak self] state in
            self?.view?.apply(state: state.mapState)
        }
    }

    private func handleDataEffect(_ effect: HomeEffect.DataEffect) {
        switch effect {
        case .loadData:
            service.loadData()
        }
    }

    private func handleUiEffect(_ effect: HomeEffect.UIEffect) {
        switch effect {
        case .moveMapToUserLocation:
            do {
                let location = try locationManager.getUserCurrentLocation()
                store.dispatch(event: .data(.onGetUserLocation(location)))
            } catch {
                break
            }
        }
    }
}

// MARK: - HomePresenterProtocol

extension HomePresenter: HomePresenterProtocol {

    func dispatch(_ event: HomeEvent.UIEvent) {
        store.dispatch(event: .ui(event))
    }
}
