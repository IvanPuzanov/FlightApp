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
        let state = FlightDetailsState(
            flight: inputData.flight,
            headerState: .initial
        )
        let reducer = FlightDetailsReducer()
        let dataEffectHandler = FlightDetailsDataEffectHandler()
        let store = FlightDetailsStore(
            state: state,
            reducer: reducer,
            dataEffectHandler: dataEffectHandler
        )
        let configurationFactory = FlightDetailsConfigurationFactory()
        let viewController = FlightDetailsViewController(
            store: store,
            configurationFactory: configurationFactory
        )

        return viewController
    }
}
