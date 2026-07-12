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
        airlineCode: String = "SU",
        airlineName: String = "Aeroflot",
        airlineLogo: String? = nil,
        originCity: String = "Moscow",
        originIata: String = "SVO",
        originCountry: String = "Russia",
        destinationCity: String = "Saint Petersburg",
        destinationIata: String = "LED",
        destinationCountry: String = "Russia",
        departureDateTime: String = "2026-08-12T06:35:00+03:00",
        arrivalDateTime: String = "2026-08-12T08:00:00+03:00",
        price: Decimal = 100,
        currency: String = "EUR",
        baggage: BaggageResponseModel = .fake(),
        layovers: [LayoverResponseModel] = [],
        status: StatusResponseModel? = .regular
    ) -> FlightResponseModel {
        FlightResponseModel(
            id: id,
            airline: AirlineResponseModel(
                code: airlineCode,
                name: airlineName,
                logo: airlineLogo
            ),
            origin: AirportResponseModel(
                iata: originIata,
                city: originCity,
                country: originCountry
            ),
            destination: AirportResponseModel(
                iata: destinationIata,
                city: destinationCity,
                country: destinationCountry
            ),
            departureDateTime: departureDateTime,
            arrivalDateTime: arrivalDateTime,
            price: price,
            currency: currency,
            baggage: baggage,
            layovers: layovers,
            status: status
        )
    }
}

extension FlightResponseModel.BaggageResponseModel {

    static func fake(
        cabinBaggageKg: Int = 8,
        cabinBaggagePieces: Int = 1,
        checkedBaggageKg: Int = 0,
        checkedBaggagePieces: Int = 0
    ) -> FlightResponseModel.BaggageResponseModel {
        FlightResponseModel.BaggageResponseModel(
            cabinBaggageKg: cabinBaggageKg,
            cabinBaggagePieces: cabinBaggagePieces,
            checkedBaggageKg: checkedBaggageKg,
            checkedBaggagePieces: checkedBaggagePieces
        )
    }
}
