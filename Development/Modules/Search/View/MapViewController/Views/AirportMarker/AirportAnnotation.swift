//
//  AirportAnnotation.swift
//  flight-demo
//
//  Created by Ivan Puzanov on 07.07.2026.
//

import MapKit

final class AirportAnnotation: NSObject, MKAnnotation {
    let id: Int
    let coordinate: CLLocationCoordinate2D
    let configuration: AirportMarkerViewConfiguration

    init(
        id: Int,
        coordinate: CLLocationCoordinate2D,
        configuration: AirportMarkerViewConfiguration
    ) {
        self.id = id
        self.coordinate = coordinate
        self.configuration = configuration
    }
}

