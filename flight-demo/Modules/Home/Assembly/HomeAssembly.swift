//
//  HomeAssembly.swift
//  flight-demo
//
//  Created by Ivan Puzanov on 28.06.2026.
//

import UIKit

protocol HomeAssemblyProtocol: AnyObject {
    func assemble() -> UIViewController
}

final class HomeAssembly: HomeAssemblyProtocol {

    // MARK: - Public

    func assemble() -> UIViewController {
        let reducer = HomeReducer()
        let store = HomeStore(reducer: reducer)
        let localStorageService = LocalStorageService()
        let localDataSource = LocalDataSource(localStorageService: localStorageService)
        let repository = Repository(localDataSource: localDataSource)
        let service = HomeService(repository: repository)
        let locationManager = LocationManager()
        let presenter = HomePresenter(
            store: store,
            service: service,
            locationManager: locationManager
        )
        let homeHeaderConfigurationFactroy = HomeHeaderConfigurationFactory()
        let headerView = HomeHeaderView(configurationFactory: homeHeaderConfigurationFactroy)
        let mapViewController = HomeMapViewController(presenter: presenter)
        let flightListConfigurationFactory = HomeFlightListConfigurationFactory()
        let flightListView = HomeFlightListView(
            presenter: presenter,
            configurationFactory: flightListConfigurationFactory
        )
        let flightListBottomSheet = BottomSheetViewController(contentView: flightListView)
        let viewController = HomeViewController(
            presenter: presenter,
            headerView: headerView,
            mapViewController: mapViewController,
            flightListBottomSheet: flightListBottomSheet
        )

        presenter.headerView = headerView
        presenter.mapView = mapViewController
        presenter.flightListView = flightListView

        return viewController
    }
}
