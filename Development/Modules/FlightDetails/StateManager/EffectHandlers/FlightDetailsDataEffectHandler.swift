//
//  FlightDetailsDataEffectHandler.swift
//  FlightDemoApp
//
//  Created by Ivan Puzanov on 17.07.2026.
//

import Foundation

protocol FlightDetailsDataEffectHandlerProtocol {
    func handle(
        _ effect: FlightDetailsEffect.DataEffect,
        completion: (FlightDetailsEvent) -> Void
    )
}

final class FlightDetailsDataEffectHandler: FlightDetailsDataEffectHandlerProtocol {

    // MARK: - Public

    func handle(
        _ effect: FlightDetailsEffect.DataEffect,
        completion: (FlightDetailsEvent) -> Void
    ) {
        switch effect {
        case let .loadDetails(flightId):
            return
        }
    }
}
