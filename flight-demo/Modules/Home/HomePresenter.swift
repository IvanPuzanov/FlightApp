//
//  HomePresenter.swift
//  flight-demo
//
//  Created by Ivan Puzanov on 28.06.2026.
//

import CoreLocation
import Combine

final class HomePresenter {

    // MARK: - Dependencies

    weak var headerView: (any HomeHeaderViewModuleInputProtocol)?
    weak var mapView: (any HomeMapModuleInputProtocol)?
    weak var flightListView: (any HomeFlightListModuleInputProtocol)?

    private var store: HomeStoreProtocol
    private let service: HomeServiceProtocol
    private let locationManager: LocationManagerProtocol

    // MARK: - Properties

    private var bag: Set<AnyCancellable> = []

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
        store.effectDidDispatch
            .sink { [weak self] effect in
                switch effect {
                case let .data(dataEffect):
                    self?.handleDataEffect(dataEffect)
                }
            }.store(in: &bag)

        store.stateDidChange
            .compactMap { [weak store] in
                store?.state.mapState
            }
            .removeDuplicates()
            .sink { [weak self] state in
                self?.mapView?.apply(state)
            }.store(in: &bag)

        store.stateDidChange
            .compactMap { [weak store] in
                store?.state.headerState
            }
            .removeDuplicates()
            .sink { [weak self] state in
                self?.headerView?.apply(state)
            }.store(in: &bag)

        store.stateDidChange
            .compactMap { [weak store] in
                store?.state.flightListState
            }
            .removeDuplicates()
            .sink { [weak self] state in
                self?.flightListView?.apply(state)
            }.store(in: &bag)
    }

    private func handleDataEffect(_ effect: HomeEffect.DataEffect) {
        switch effect {
        case .loadAirports:
            loadAirports()
        case .loadFlights:
            loadFlights()
        case .getDefaultRegionLocation:
            let location = locationManager.getDefaultLocation()
            store.dispatch(event: .data(.onGetLocation(location)))
        }
    }

    private func loadAirports() {
        service.loadAirports()
            .sink { [weak self] completion in
                guard case .failure = completion else { return }

                self?.store.dispatch(event: .data(.onAirportsFailed))
            } receiveValue: { [weak self] airports in
                self?.store.dispatch(event: .data(.onAirportsLoaded(airports)))
            }.store(in: &bag)
    }

    private func loadFlights() {
        service.loadFlights()
            .sink { [weak self] completion in
                guard case .failure = completion else { return }

                self?.store.dispatch(event: .data(.onFlightsFailed))
            } receiveValue: { [weak self] flights in
                self?.store.dispatch(event: .data(.onFlightsLoaded(flights)))
            }.store(in: &bag)
    }
}

// MARK: - HomeViewModuleOutputProtocol

extension HomePresenter: HomeViewModuleOutputProtocol, HomeHeaderViewModuleOutputProtocol, HomeMapModuleOutputProtocol, HomeFlightListModuleOutputProtocol {

    func dispatch(_ event: HomeEvent.UIEvent) {
        store.dispatch(event: .ui(event))
    }
}
