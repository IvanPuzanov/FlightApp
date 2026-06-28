//
//  HomeState.swift
//  flight-demo
//
//  Created by Ivan Puzanov on 28.06.2026.
//

import MapKit

struct HomeState: Equatable {
    var mapState: MapState
}

extension HomeState {
    static var initial: HomeState {
        HomeState(
            mapState: .initial
        )
    }
}

extension HomeState {
    struct MapState: Equatable {
        var currentLocation: Coordinate?
    }
}

extension HomeState.MapState {
    static var initial: HomeState.MapState {
        HomeState.MapState(
            currentLocation: nil
        )
    }
}
