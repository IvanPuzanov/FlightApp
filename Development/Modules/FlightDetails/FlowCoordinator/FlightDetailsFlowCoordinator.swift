//
//  FlightDetailsFlowCoordinator.swift
//  FlightDemoApp
//
//  Created by Ivan Puzanov on 09.07.2026.
//

import UIKit

final class FlightDetailsFlowCoordinator: FlowCoordinatorProtocol {

    // MARK: - Properties

    let navigationController: UINavigationController

    private let inputData: FlightDetailsInputData
    private var rootViewController: UIViewController?

    // MARK: - Initialization

    init(
        inputData: FlightDetailsInputData,
        navigationController: UINavigationController
    ) {
        self.inputData = inputData
        self.navigationController = navigationController
    }

    // MARK: - Public

    func start(animated: Bool) {
        let assembly = FlightDetailsAssembly()
        let viewController = assembly.assemble(inputData: inputData)
        rootViewController = viewController

        navigationController.topViewController?.present(viewController, animated: true)
    }
    
    func finish() {
        rootViewController?.dismiss(animated: true)
    }

}
