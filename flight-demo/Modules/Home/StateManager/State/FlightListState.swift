//
//  FlightListState.swift
//  flight-demo
//
//  Created by Ivan Puzanov on 30.06.2026.
//

import Foundation

extension HomeState {
    struct FlightListState: Equatable {
        var appearance: Appearance
        var contentState: ContentState
    }
}

extension HomeState.FlightListState {
    struct Appearance: Equatable {
        var bottomSheetDetents: [CGFloat]
        var isGrabberHidden: Bool
    }

    enum ContentState: Equatable {
        case loading
    }
}

extension HomeState.FlightListState {
    static var initial: HomeState.FlightListState {
        HomeState.FlightListState(
            appearance: Appearance(bottomSheetDetents: [], isGrabberHidden: false),
            contentState: .loading
        )
    }
}
