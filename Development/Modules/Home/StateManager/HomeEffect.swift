//
//  HomeEffect.swift
//  flight-demo
//
//  Created by Ivan Puzanov on 28.06.2026.
//

import Foundation

enum HomeEffect: Equatable {
    case data(DataEffect)
    case navigation(Navigation)
}

extension HomeEffect {
    enum DataEffect: Equatable {
        case loadAirports
        case loadFlights
        case getDefaultRegionLocation
    }

    enum Navigation: Equatable {
        case openFlightDetails(inputData: FlightDetailsInputData)
    }
}
