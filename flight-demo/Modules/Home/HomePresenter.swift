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

    weak var mapView: HomeMapViewControllerProtocol?
    weak var bottomSheetView: HomeBottomSheetViewControllerProtocol?

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
            self?.mapView?.apply(state: state.mapState)
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
        case .moveMapToDefaultRegion:
            let location = locationManager.getDefaultLocation()
            store.dispatch(event: .data(.onGetLocation(location)))
        }
    }
}

// MARK: - HomePresenterProtocol

extension HomePresenter: HomePresenterProtocol {

    func dispatch(_ event: HomeEvent.UIEvent) {
        store.dispatch(event: .ui(event))
    }
}
