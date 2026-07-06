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
        var bottomSheetState: BottomSheetState
    }
}

extension HomeState.FlightListState {
    struct Appearance: Equatable {
        let defaultCornerRadius: CGFloat
        var currentCornerRadius: CGFloat

        let defaultShadowOpacity: Float
        var currentShadowOpacity: Float

        var bottomSheetDetents: [CGFloat]
        var currentDetent: CGFloat?

        var isMapButtonHidden: Bool
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

    struct BottomSheetState: Equatable {
        var detents: [BottomSheetDetent]
        var currentDetent: BottomSheetDetent
    }

    enum BottomSheetDetent: Equatable {
        case compact(CGFloat)
        case regular(CGFloat)
        case large(CGFloat)
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
                defaultCornerRadius: 0,
                currentCornerRadius: 0,
                defaultShadowOpacity: 0,
                currentShadowOpacity: 0,
                bottomSheetDetents: [],
                currentDetent: nil,
                isMapButtonHidden: true
            ),
            parameters: Parameters(
                flights: [],
                searchText: nil
            ),
            contentState: .loading,
            bottomSheetState: BottomSheetState(
                detents: [],
                currentDetent: .compact(0)
            )
        )
    }
}
