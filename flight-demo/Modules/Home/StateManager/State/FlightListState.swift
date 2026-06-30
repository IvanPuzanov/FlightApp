//
//  FlightListState.swift
//  flight-demo
//
//  Created by Ivan Puzanov on 30.06.2026.
//

import Foundation

extension HomeState {
    struct FlightListState: Equatable {
        var bottomSheetDetents: [CGFloat]
        var isGrabberHidden: Bool
    }
}

extension HomeState.FlightListState {
    static var initial: HomeState.FlightListState {
        HomeState.FlightListState(
            bottomSheetDetents: [],
            isGrabberHidden: false
        )
    }
}
