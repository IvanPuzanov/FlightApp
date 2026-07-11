//
//  FlightDetailsInputData+fake.swift
//  FlightDemoApp
//
//  Created by Ivan Puzanov on 10.07.2026.
//

import Foundation
@testable import FlightDemoApp

extension FlightDetailsInputData {

    static func fake(
        flight: Flight = .fake()
    ) -> FlightDetailsInputData {
        FlightDetailsInputData(flight: flight)
    }
}
