//
//  NavigationEffectHandler.swift
//  FlightDemoApp
//
//  Created by Ivan Puzanov on 09.07.2026.
//

import Foundation

protocol NavigationEffectHandlerProtocol: AnyObject {
    func handle(
        _ effect: SearchEffect.Navigation,
        completion: @escaping (SearchEvent) -> Void
    )
}

final class NavigationEffectHandler: NavigationEffectHandlerProtocol {

    // MARK: - Dependencies

    weak var moduleOutput: SearchModuleOutput?

    // MARK: - Initialization

    init(moduleOutput: SearchModuleOutput) {
        self.moduleOutput = moduleOutput
    }

    // MARK: - Public

    func handle(
        _ effect: SearchEffect.Navigation,
        completion: @escaping (SearchEvent) -> Void
    ) {
        switch effect {
        case let .openFlightDetails(inputData):
            moduleOutput?.moduleWantsToOpenFlightDetails(inputData: inputData)
        case .closeFlightDetails:
            moduleOutput?.moduleWantsToCloseFlightDetails()
        }
    }
}
