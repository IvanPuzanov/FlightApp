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
        let localStorageService = LocalStorageService()
        let localDataSource = LocalDataSource(localStorageService: localStorageService)
        let locationService = LocationService()
        let repository = Repository(
            localDataSource: localDataSource,
            locationService: locationService
        )
        let service = HomeService(repository: repository)
        let effectHandlers = [
            DataEffectHandler(service: service)
        ]
        let reducer = HomeReducer()
        let store = HomeStore(
            reducer: reducer,
            effectHandlers: effectHandlers
        )
        let homeHeaderConfigurationFactroy = HomeHeaderConfigurationFactory()
        let headerView = HomeHeaderView(
            store: store,
            configurationFactory: homeHeaderConfigurationFactroy
        )
        let factory = HomeMapViewControllerFactory()
        let mapViewController = HomeMapViewController(
            store: store,
            factory: factory
        )
        let flightListConfigurationFactory = HomeFlightListConfigurationFactory()
        let flightListView = HomeFlightListView(
            store: store,
            configurationFactory: flightListConfigurationFactory
        )
        let flightListBottomSheet = BottomSheetViewController(contentView: flightListView)
        let viewController = HomeViewController(
            store: store,
            headerView: headerView,
            mapViewController: mapViewController,
            flightListBottomSheet: flightListBottomSheet
        )

        homeHeaderConfigurationFactroy.delegate = headerView
        flightListConfigurationFactory.delegate = flightListView

        return viewController
    }
}
