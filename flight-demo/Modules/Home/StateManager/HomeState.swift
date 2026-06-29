//
//  HomeState.swift
//  flight-demo
//
//  Created by Ivan Puzanov on 28.06.2026.
//

import MapKit

struct HomeState: Equatable {
    var mapState: MapState
    var bottomSheetState: BottomSheetState
}

extension HomeState {
    struct MapState: Equatable {
        var currentLocation: Coordinate?
    }

    struct BottomSheetState: Equatable {
        var detents: [Detent]
    }
}

extension HomeState.BottomSheetState {
    enum Detent: Equatable {
        case compact(CGFloat)
        case medium(CGFloat)
        case custom(CGFloat)
    }
}

extension HomeState {
    static var initial: HomeState {
        HomeState(
            mapState: .initial,
            bottomSheetState: .initial
        )
    }
}

extension HomeState.MapState {
    static var initial: HomeState.MapState {
        HomeState.MapState(
            currentLocation: nil
        )
    }
}

extension HomeState.BottomSheetState {
    static var initial: HomeState.BottomSheetState {
        HomeState.BottomSheetState(
            detents: []
        )
    }
}
