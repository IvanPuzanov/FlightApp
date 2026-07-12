//
//  FlowCoordinatorProtocol.swift
//  flight-demo
//
//  Created by Ivan Puzanov on 28.06.2026.
//

import UIKit

@MainActor
protocol FlowCoordinatorProtocol: AnyObject {
    var navigationController: UINavigationController { get }

    func start(animated: Bool)
    func finish()
}
