//
//  HomePresenter.swift
//  flight-demo
//
//  Created by Ivan Puzanov on 28.06.2026.
//

import CoreLocation

final class HomePresenter {

    // MARK: - Dependencies

    weak var headerView: (any HomeHeaderViewModuleInputProtocol)?
    weak var mapView: (any HomeMapModuleInputProtocol)?
    weak var flightListView: (any HomeFlightListModuleInputProtocol)?

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
                handleDataEffect(dataEffect)
            case let .ui(uiEffect):
                handleUiEffect(uiEffect)
            }
        }

        store.didUpdateState = { [weak self] state in
            self?.headerView?.apply(state.headerState)
            self?.mapView?.apply(state.mapState)
            self?.flightListView?.apply(state.flightListState)
        }
    }

    private func handleDataEffect(_ effect: HomeEffect.DataEffect) {
        switch effect {
        case .loadData:
            service.loadData()
        case .getDefaultRegionLocation:
            let location = locationManager.getDefaultLocation()
            store.dispatch(event: .data(.onGetLocation(location)))
        }
    }

    private func handleUiEffect(_ effect: HomeEffect.UIEffect) {}
}

// MARK: - ModuleOutputProtocol

extension HomePresenter: HomeHeaderViewModuleOutputProtocol, HomeMapModuleOutputProtocol, HomeFlightListModuleOutputProtocol {

    func dispatch(_ event: HomeEvent.UIEvent) {
        store.dispatch(event: .ui(event))
    }
}
