//
//  HomeEffect.swift
//  flight-demo
//
//  Created by Ivan Puzanov on 28.06.2026.
//

import Foundation

enum HomeEffect {
    case data(DataEffect)
}

extension HomeEffect {
    enum DataEffect {
        case loadAirports
        case loadFlights
        case getDefaultRegionLocation
    }
}
