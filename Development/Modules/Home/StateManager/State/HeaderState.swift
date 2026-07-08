//
//  HeaderState.swift
//  flight-demo
//
//  Created by Ivan Puzanov on 30.06.2026.
//

import Foundation

extension HomeState {
    struct HeaderState: Equatable {
        var mode: Mode
        var bottomSheetProgress: CGFloat
    }
}

extension HomeState.HeaderState {
    enum Mode: Equatable {
        case flightInfo(number: String, description: String)
        case search(text: String?)
    }
}

extension HomeState.HeaderState {
    static var initial: HomeState.HeaderState {
        HomeState.HeaderState(
            mode: .search(text: nil),
            bottomSheetProgress: .zero
        )
    }
}
