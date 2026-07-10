//
//  AppFlowCoordinator.swift
//  FlightDemoApp
//
//  Created by Ivan Puzanov on 10.07.2026.
//

import UIKit

final class AppFlowCoordinator: FlowCoordinatorProtocol {

    // MARK: - Properties

    private let window: UIWindow
    var navigationController = UINavigationController()

    private var childCoordinators: [FlowCoordinatorProtocol] = []

    // MARK: - Initialization

    init(window: UIWindow) {
        self.window = window
    }

    // MARK: - Public

    func start(animated: Bool) {
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        startHome(animated: animated)
    }

    func finish() {}

    // MARK: - Private

    private func startHome(animated: Bool) {
        let homeAssembly = HomeAssembly()
        let homeFlowCoordinator = HomeFlowCoordinator(
            assembly: homeAssembly,
            navigationController: navigationController
        )
        homeFlowCoordinator.start(animated: animated)

        childCoordinators.append(homeFlowCoordinator)
    }
}
