//
//  AppDelegate.swift
//  flight-demo
//
//  Created by Ivan Puzanov on 28.06.2026.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var homeFlowCoordinator: HomeFlowCoordinator?
    var navigationController: UINavigationController?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        navigationController = UINavigationController()
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        startHome()

        return true
    }

    // MARK: - Private

    private func startHome() {
        guard let navigationController else { return }

        let homeAssembly = HomeAssembly()
        homeFlowCoordinator = HomeFlowCoordinator(
            assembly: homeAssembly,
            navigationController: navigationController
        )
        homeFlowCoordinator?.start(animated: true)
    }
}

