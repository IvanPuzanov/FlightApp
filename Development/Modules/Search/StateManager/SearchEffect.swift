//
//  SearchEffect.swift
//  flight-demo
//
//  Created by Ivan Puzanov on 28.06.2026.
//

import Foundation

enum SearchEffect: Equatable {
    case data(DataEffect)
    case navigation(Navigation)
}

extension SearchEffect {
    enum DataEffect: Equatable {
        case loadAirports
        case loadFlights
        case getDefaultRegionLocation
    }

    enum Navigation: Equatable {
        case openFlightDetails(inputData: FlightDetailsInputData)
    }
}
