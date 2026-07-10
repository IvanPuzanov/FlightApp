//
//  SearchState.swift
//  flight-demo
//
//  Created by Ivan Puzanov on 28.06.2026.
//

import MapKit

struct SearchState: Equatable {
    var headerState: HeaderState
    var mapState: MapState
    var flightListState: FlightListState
}

extension SearchState {
    static var initial: SearchState {
        SearchState(
            headerState: .initial,
            mapState: .initial,
            flightListState: .initial
        )
    }
}
