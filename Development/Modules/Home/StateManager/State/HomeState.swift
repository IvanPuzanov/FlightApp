//
//  HomeState.swift
//  flight-demo
//
//  Created by Ivan Puzanov on 28.06.2026.
//

import MapKit

struct HomeState: Equatable {
    var headerState: HeaderState
    var mapState: MapState
    var flightListState: FlightListState
}

extension HomeState {
    static var initial: HomeState {
        HomeState(
            headerState: .initial,
            mapState: .initial,
            flightListState: .initial
        )
    }
}
