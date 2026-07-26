//
//  FlightDetailsEffect.swift
//  FlightDemoApp
//
//  Created by Ivan Puzanov on 09.07.2026.
//

import Foundation

enum FlightDetailsEffect {
    case data(DataEffect)
    case navigation(Navigation)
}

extension FlightDetailsEffect {

    enum DataEffect {
        case loadDetails(flightId: String)
    }

    enum Navigation {
        case closeFlightDetailsModule
    }
}
