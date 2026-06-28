//
//  Coordinate.swift
//  flight-demo
//
//  Created by Ivan Puzanov on 28.06.2026.
//

import CoreLocation

struct Coordinate: Equatable {
    let latitude: Double
    let longitude: Double

    var toCLLocationCoordinate2D: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
