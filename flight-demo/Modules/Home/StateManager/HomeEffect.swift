//
//  HomeEffect.swift
//  flight-demo
//
//  Created by Ivan Puzanov on 28.06.2026.
//

import Foundation

enum HomeEffect {
    case ui(UIEffect)
    case data(DataEffect)
}

extension HomeEffect {
    enum UIEffect {}

    enum DataEffect {
        case loadData
        case getDefaultRegionLocation
    }
}
