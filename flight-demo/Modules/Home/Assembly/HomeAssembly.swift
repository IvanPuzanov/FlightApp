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
        let presenter = HomePresenter(
            store: store,
            service: service
        )
        let viewController = HomeViewController(
            presenter: presenter
        )
        return viewController
    }
}
