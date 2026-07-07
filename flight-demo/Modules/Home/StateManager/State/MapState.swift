//
//  MapState.swift
//  flight-demo
//
//  Created by Ivan Puzanov on 30.06.2026.
//

import Foundation

extension HomeState {
    struct MapState: Equatable {
        var defaultRegionCoordinate: Coordinate?
        var airports: [Airport]
    }
}

extension HomeState.MapState {
    static var initial: HomeState.MapState {
        HomeState.MapState(
            defaultRegionCoordinate: nil,
            airports: []
        )
    }
}
