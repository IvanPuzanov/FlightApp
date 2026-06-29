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
        let presenter = HomePresenter(
            store: store,
            service: service,
            locationManager: locationManager
        )
        let configurationFactory = HomeConfigurationFactory()
        let bottomSheetViewController = HomeBottomSheetViewController(
            presenter: presenter,
            configurationFactory: configurationFactory
        )
        let mapViewController = HomeMapViewController(
            presenter: presenter,
            configurationFactory: configurationFactory,
            bottomSheetViewController: bottomSheetViewController
        )
        presenter.mapView = mapViewController
        presenter.bottomSheetView = bottomSheetViewController

        return mapViewController
    }
}
