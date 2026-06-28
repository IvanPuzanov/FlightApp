//
//  HomeEvent.swift
//  flight-demo
//
//  Created by Ivan Puzanov on 28.06.2026.
//

import MapKit

enum HomeEvent {
    case ui(UIEvent)
    case data(DataEvent)
}

extension HomeEvent {
    enum UIEvent {
        case onViewDidLoad
        case onMapDidLoad
    }

    enum DataEvent {
        case onGetLocation(Coordinate)
    }
}
