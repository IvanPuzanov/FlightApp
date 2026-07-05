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
        var parameters: Parameters
        var contentState: ContentState
    }
}

extension HomeState.FlightListState {
    struct Appearance: Equatable {
        var bottomSheetDetents: [CGFloat]
        var bottomSheetProgress: CGFloat
    }

    struct Parameters: Equatable {
        var flights: [Flight]
        var searchText: String?
    }

    enum ContentState: Equatable {
        case loading
        case status(Status)
        case content([Flight])
    }

    enum Status {
        case error
        case empty
    }
}

extension HomeState.FlightListState {
    static var initial: HomeState.FlightListState {
        HomeState.FlightListState(
            appearance: Appearance(
                bottomSheetDetents: [],
                bottomSheetProgress: 0
            ),
            parameters: Parameters(
                flights: [],
                searchText: nil
            ),
            contentState: .loading
        )
    }
}
