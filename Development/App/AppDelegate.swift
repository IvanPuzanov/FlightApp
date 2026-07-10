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
    var appCoordinator: FlowCoordinatorProtocol?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window

        appCoordinator = AppFlowCoordinator(window: window)
        appCoordinator?.start(animated: true)

        return true
    }
}

