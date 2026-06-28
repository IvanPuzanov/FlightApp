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
    struct MapState {
        var isUserLocationSetted: Bool {
            currentLocation != nil
        }
        var currentLocation: CLLocationCoordinate2D?
    }
}

extension HomeState.MapState {
    static var initial: HomeState.MapState {
        HomeState.MapState(
            currentLocation: nil
        )
    }
}

extension HomeState.MapState: Equatable {
    static func == (lhs: HomeState.MapState, rhs: HomeState.MapState) -> Bool {
        lhs.isUserLocationSetted == rhs.isUserLocationSetted
    }
}
