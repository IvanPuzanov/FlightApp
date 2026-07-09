//
//  FlightDetailsEvent.swift
//  FlightDemoApp
//
//  Created by Ivan Puzanov on 09.07.2026.
//

import Foundation

enum FlightDetailsEvent {
    case ui(UIEvent)
}

extension FlightDetailsEvent {

    enum UIEvent {
        case onCloseButtonTap
    }
}
