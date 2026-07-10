//
//  FlightListState.swift
//  flight-demo
//
//  Created by Ivan Puzanov on 30.06.2026.
//

import Foundation

extension SearchState {
    struct FlightListState: Equatable {
        var appearance: Appearance
        var parameters: Parameters
        var contentState: ContentState
        var bottomSheetState: BottomSheetState
    }
}

extension SearchState.FlightListState {
    struct Appearance: Equatable {
        let defaultCornerRadius: CGFloat
        var currentCornerRadius: CGFloat

        let defaultShadowOpacity: Float
        var currentShadowOpacity: Float

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

    enum BottomSheetDetentID: Equatable {
        case compact
        case regular
        case large
    }

    struct BottomSheetDetent: Equatable {
        let id: BottomSheetDetentID
        let height: CGFloat
    }

    enum Status {
        case error
        case empty
    }
}

extension SearchState.FlightListState {
    static var initial: SearchState.FlightListState {
        SearchState.FlightListState(
            appearance: Appearance(
                defaultCornerRadius: 0,
                currentCornerRadius: 0,
                defaultShadowOpacity: 0,
                currentShadowOpacity: 0,
                isMapButtonHidden: true
            ),
            parameters: Parameters(
                flights: [],
                searchText: nil
            ),
            contentState: .loading,
            bottomSheetState: BottomSheetState(
                detents: [],
                currentDetent: BottomSheetDetent(id: .compact, height: 0)
            )
        )
    }
}
