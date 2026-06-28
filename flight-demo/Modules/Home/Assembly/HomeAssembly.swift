//
//  HomeAssembly.swift
//  flight-demo
//
//  Created by Ivan Puzanov on 28.06.2026.
//

import UIKit

final class HomeAssembly: AssemblyProtocol {

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
        let viewController = HomeViewController(
            presenter: presenter
        )
        presenter.view = viewController
        return viewController
    }
}
