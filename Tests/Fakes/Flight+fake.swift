//
//  Flight+fake.swift
//  FlightDemoApp
//
//  Created by Ivan Puzanov on 10.07.2026.
//

import Foundation
@testable import FlightDemoApp

extension Flight {

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
        status: FlightResponseModel.FlightStatus = .boarding
    ) -> Flight {
        Flight(
            from: .fake(
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
        )
    }
}
