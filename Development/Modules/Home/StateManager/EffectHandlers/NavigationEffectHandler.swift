//
//  NavigationEffectHandler.swift
//  FlightDemoApp
//
//  Created by Ivan Puzanov on 09.07.2026.
//

import Foundation

final class NavigationEffectHandler: EffectHandlerProtocol {

    // MARK: - Dependencies

    weak var moduleOutput: HomeModuleOutput?

    // MARK: - Initialization

    init(moduleOutput: HomeModuleOutput) {
        self.moduleOutput = moduleOutput
    }

    // MARK: - Public

    func handle(_ effect: HomeEffect, completion: @escaping (HomeEvent) -> Void) {
        switch effect {
        case let .navigation(navigationEffect):
            switch navigationEffect {
            case let .openFlightDetails(inputData):
                moduleOutput?.moduleWantsToOpenFlightDetails(inputData: inputData)
            }
        case .data:
            break
        }
    }
}
