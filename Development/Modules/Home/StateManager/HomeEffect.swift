//
//  HomeEffect.swift
//  flight-demo
//
//  Created by Ivan Puzanov on 28.06.2026.
//

import Foundation

enum HomeEffect: Equatable {
    case data(DataEffect)
}

extension HomeEffect {
    enum DataEffect: Equatable {
        case loadAirports
        case loadFlights
        case getDefaultRegionLocation
    }
}
