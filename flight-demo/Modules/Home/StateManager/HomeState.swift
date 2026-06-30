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
    struct MapState: Equatable {
        var currentLocation: Coordinate?
        var headerState: HeaderState
    }

    enum HeaderState: Equatable {
        case flightInfo(number: String, description: String)
        case search(text: String?)
    }

    struct FlightListState: Equatable {
        var bottomSheetDetents: [CGFloat]
    }
}

extension HomeState {
    static var initial: HomeState {
        HomeState(
            headerState: .search(text: nil),
            mapState: .initial,
            flightListState: FlightListState(
                bottomSheetDetents: []
            )
        )
    }
}

extension HomeState.MapState {
    static var initial: HomeState.MapState {
        HomeState.MapState(
            currentLocation: nil,
            headerState: .search(text: nil)
        )
    }
}
