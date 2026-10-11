//
//  SceneDelegate.swift
//  FlightDemoApp
//
//  Created by Ivan Puzanov on 11.10.2026.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var appCoordinator: FlowCoordinatorProtocol?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = scene as? UIWindowScene else { return }

        let window = UIWindow(windowScene: windowScene)
        self.window = window

        appCoordinator = AppFlowCoordinator(window: window)
        appCoordinator?.start(animated: true)
    }
}
