//
//  FlightDetailsAssembly.swift
//  FlightDemoApp
//
//  Created by Ivan Puzanov on 09.07.2026.
//

import UIKit

protocol FlightDetailsAssemblyProtocol: AnyObject {
    func assemble(inputData: FlightDetailsInputData) -> UIViewController
}

final class FlightDetailsAssembly: FlightDetailsAssemblyProtocol {

    // MARK: - Public

    func assemble(inputData: FlightDetailsInputData) -> UIViewController {
        let viewController = FlightDetailsViewController()

        return viewController
    }
}
