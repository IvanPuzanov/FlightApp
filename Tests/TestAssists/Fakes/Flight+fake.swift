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
        airlineCode: String = "SU",
        airlineName: String = "Aeroflot",
        originCity: String = "Moscow",
        originIata: String = "SVO",
        destinationCity: String = "Saint Petersburg",
        destinationIata: String = "LED",
        price: Decimal = 100,
        currency: String = "EUR",
        baggage: FlightResponseModel.BaggageResponseModel = .fake(),
        status: FlightResponseModel.StatusResponseModel? = .regular
    ) -> Flight {
        Flight(
            from: .fake(
                id: id,
                airlineCode: airlineCode,
                airlineName: airlineName,
                originCity: originCity,
                originIata: originIata,
                destinationCity: destinationCity,
                destinationIata: destinationIata,
                price: price,
                currency: currency,
                baggage: baggage,
                status: status
            )
        )
    }
}
