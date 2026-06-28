//
//  HomeEvent.swift
//  flight-demo
//
//  Created by Ivan Puzanov on 28.06.2026.
//

import Foundation

enum HomeEvent {
    case ui(UIEvent)
}

extension HomeEvent {
    enum UIEvent {
        case onViewDidLoad
    }
}
