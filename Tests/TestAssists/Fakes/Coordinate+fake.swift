//
//  Coordinate+fake.swift
//  FlightDemoApp
//
//  Created by Ivan Puzanov on 10.07.2026.
//

import Foundation
@testable import FlightDemoApp

extension Coordinate {

    static func fake(
        latitude: Double = 55.75,
        longitude: Double = 37.62
    ) -> Coordinate {
        Coordinate(
            latitude: latitude,
            longitude: longitude
        )
    }
}
