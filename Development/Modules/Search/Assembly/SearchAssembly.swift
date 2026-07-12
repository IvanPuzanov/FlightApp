//
//  SearchAssembly.swift
//  flight-demo
//
//  Created by Ivan Puzanov on 28.06.2026.
//

import UIKit

protocol SearchAssemblyProtocol: AnyObject {
    func assemble(output: SearchModuleOutput) -> UIViewController
}

final class SearchAssembly: SearchAssemblyProtocol {

    // MARK: - Public

    func assemble(output: SearchModuleOutput) -> UIViewController {
        let urlSession = URLSession(configuration: .default)
        let networkService = NetworkService(urlSession: urlSession)
        let remoteDataSource = RemoteDataSource(
            baseURL: URL(
                string: "https://raw.githubusercontent.com/IvanPuzanov/FlightAppMockAPI/main"
            )!,
            networkService: networkService
        )
        let locationService = LocationService()
        let repository = Repository(
            remoteDataSource: remoteDataSource,
            locationService: locationService
        )
        let service = SearchService(repository: repository)
        let effectHandlers: [EffectHandlerProtocol] = [
            DataEffectHandler(service: service),
            NavigationEffectHandler(moduleOutput: output)
        ]
        let reducer = SearchReducer()
        let store = SearchStore(
            reducer: reducer,
            effectHandlers: effectHandlers
        )
        let searchHeaderConfigurationFactroy = SearchHeaderConfigurationFactory()
        let headerView = SearchHeaderView(
            store: store,
            configurationFactory: searchHeaderConfigurationFactroy
        )
        let factory = SearchMapViewControllerFactory()
        let mapViewController = SearchMapViewController(
            store: store,
            factory: factory
        )
        let flightListConfigurationFactory = SearchFlightListConfigurationFactory()
        let flightListView = SearchFlightListView(
            store: store,
            configurationFactory: flightListConfigurationFactory
        )
        let flightListBottomSheet = BottomSheetViewController(contentView: flightListView)
        let viewController = SearchViewController(
            store: store,
            headerView: headerView,
            mapViewController: mapViewController,
            flightListBottomSheet: flightListBottomSheet
        )

        searchHeaderConfigurationFactroy.delegate = headerView
        flightListConfigurationFactory.delegate = flightListView

        return viewController
    }
}
