//
//  FlightResponseModel+fake.swift
//  FlightDemoApp
//
//  Created by Ivan Puzanov on 10.07.2026.
//

import Foundation
@testable import FlightDemoApp

extension FlightResponseModel {

    static func fake(
        id: String = "flight-1",
        flightNumber: String = "SU100",
        airline: String = "Aeroflot",
        airlineCode: String = "SU",
        aircraft: String = "A320",
        originCity: String = "Moscow",
        originIata: String = "SVO",
        destinationCity: String = "Saint Petersburg",
        destinationIata: String = "LED",
        status: FlightStatus = .boarding
    ) -> FlightResponseModel {
        FlightResponseModel(
            id: id,
            flightNumber: flightNumber,
            airline: airline,
            airlineCode: airlineCode,
            aircraft: aircraft,
            originCity: originCity,
            originIata: originIata,
            destinationCity: destinationCity,
            destinationIata: destinationIata,
            status: status
        )
    }
}
