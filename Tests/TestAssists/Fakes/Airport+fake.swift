//
//  Airport+fake.swift
//  FlightDemoApp
//
//  Created by Ivan Puzanov on 10.07.2026.
//

import Foundation
@testable import FlightDemoApp

extension Airport {

    static func fake(
        id: Int = 1,
        iata: String = "SVO",
        city: String = "Moscow",
        country: String = "Russia",
        latitude: Double = 55.97,
        longitude: Double = 37.41
    ) -> Airport {
        Airport(
            from: .fake(
                id: id,
                iata: iata,
                city: city,
                country: country,
                latitude: latitude,
                longitude: longitude
            )
        )
    }
}
