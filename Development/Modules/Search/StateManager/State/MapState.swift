//
//  MapState.swift
//  flight-demo
//
//  Created by Ivan Puzanov on 30.06.2026.
//

import Foundation

extension SearchState {
    struct MapState: Equatable {
        var isDefaultRegionSetted: Bool
        var defaultRegionCoordinate: Coordinate?
        var airports: [Airport]
    }
}

extension SearchState.MapState {
    static var initial: SearchState.MapState {
        SearchState.MapState(
            isDefaultRegionSetted: false,
            defaultRegionCoordinate: nil,
            airports: []
        )
    }
}
