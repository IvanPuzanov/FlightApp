//
//  SearchFlowCoordinator.swift
//  flight-demo
//
//  Created by Ivan Puzanov on 28.06.2026.
//

import UIKit

protocol SearchModuleOutput: AnyObject {
    func moduleWantsToOpenFlightDetails(inputData: FlightDetailsInputData)
}

final class SearchFlowCoordinator: FlowCoordinatorProtocol {

    // MARK: - Dependencies

    private let assembly: SearchAssemblyProtocol

    // MARK: - Properties

    var navigationController: UINavigationController
    private var childCoordinators: [FlowCoordinatorProtocol] = []

    // MARK: - Initialization

    init(
        assembly: SearchAssemblyProtocol,
        navigationController: UINavigationController
    ) {
        self.assembly = assembly
        self.navigationController = navigationController
    }

    // MARK: - Public

    func start(animated: Bool) {
        let viewController = assembly.assemble(output: self)
        navigationController.pushViewController(viewController, animated: animated)
    }

    func finish() {}
}

// MARK: - SearchModuleOutput

extension SearchFlowCoordinator: SearchModuleOutput {

    func moduleWantsToOpenFlightDetails(inputData: FlightDetailsInputData) {
        let flowCoordinator = FlightDetailsFlowCoordinator(
            inputData: inputData,
            navigationController: navigationController
        )
        childCoordinators.append(flowCoordinator)
        flowCoordinator.start(animated: true)
    }
}
