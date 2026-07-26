//
//  FlightDetailsState.swift
//  FlightDemoApp
//
//  Created by Ivan Puzanov on 09.07.2026.
//

import Foundation

struct FlightDetailsState: Equatable {
    @Equated var flight: Flight
    var headerState: HeaderState
}

extension FlightDetailsState {

    struct HeaderState: Equatable {
        var originIata: String
        var originCity: String
        var destinationIata: String
        var destinationCity: String
    }
}

extension FlightDetailsState.HeaderState {

    static var initial: FlightDetailsState.HeaderState {
        FlightDetailsState.HeaderState(
            originIata: String(),
            originCity: String(),
            destinationIata: String(),
            destinationCity: String()
        )
    }
}
