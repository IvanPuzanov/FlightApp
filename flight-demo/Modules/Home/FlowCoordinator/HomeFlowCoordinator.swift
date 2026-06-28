//
//  HomeFlowCoordinator.swift
//  flight-demo
//
//  Created by Ivan Puzanov on 28.06.2026.
//

import UIKit

final class HomeFlowCoordinator: FlowCoordinatorProtocol {

    // MARK: - Dependencies

    private let assembly: AssemblyProtocol

    // MARK: - Properties

    var navigationController: UINavigationController

    // MARK: - Initialization

    init(
        assembly: AssemblyProtocol,
        navigationController: UINavigationController
    ) {
        self.assembly = assembly
        self.navigationController = navigationController
    }

    // MARK: - Public

    func start(animated: Bool) {
        let viewController = assembly.assemble()
        navigationController.pushViewController(viewController, animated: animated)
    }

    func finish() {}
}
