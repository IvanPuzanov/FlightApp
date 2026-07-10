//
//  HeaderState.swift
//  flight-demo
//
//  Created by Ivan Puzanov on 30.06.2026.
//

import Foundation

extension SearchState {
    struct HeaderState: Equatable {
        var mode: Mode
        var bottomSheetProgress: CGFloat
    }
}

extension SearchState.HeaderState {
    enum Mode: Equatable {
        case flightInfo(number: String, description: String)
        case search(text: String?)
    }
}

extension SearchState.HeaderState {
    static var initial: SearchState.HeaderState {
        SearchState.HeaderState(
            mode: .search(text: nil),
            bottomSheetProgress: .zero
        )
    }
}
