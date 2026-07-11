//
//  Airport.swift
//  flight-demo
//
//  Created by Ivan Puzanov on 01.07.2026.
//

import MapKit

struct Airport: Equatable {
    let id: Int
    let iata: String
    let city: String
    let country: String
    @Equated var location: CLLocationCoordinate2D

    init(from model: AirportResponseModel) {
        self.id = model.id
        self.iata = model.iata
        self.city = model.city
        self.country = model.country
        self.location = CLLocationCoordinate2D(
            latitude: CLLocationDegrees(model.latitude),
            longitude: CLLocationDegrees(model.longitude)
        )
    }
}
