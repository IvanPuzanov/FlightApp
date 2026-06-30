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
        let service = HomeService()
        let locationManager = LocationManager()
        let configurationFactory = HomeConfigurationFactory()

        let presenter = HomePresenter(
            store: store,
            service: service,
            locationManager: locationManager
        )
        let headerView = HomeHeaderView(configurationFactory: configurationFactory)
        let mapViewController = HomeMapViewController(presenter: presenter)
        let flightListView = HomeFlightListView(presenter: presenter)
        let flightListBottomSheet = BottomSheetViewController(contentView: flightListView)
        let viewController = HomeViewController(
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
