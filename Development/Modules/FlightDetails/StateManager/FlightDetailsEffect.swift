//
//  FlightDetailsEffect.swift
//  FlightDemoApp
//
//  Created by Ivan Puzanov on 09.07.2026.
//

import Foundation

enum FlightDetailsEffect {
    case navigation(Navigation)
}

extension FlightDetailsEffect {

    enum Navigation {
        case closeFlightDetailsModule
    }
}
