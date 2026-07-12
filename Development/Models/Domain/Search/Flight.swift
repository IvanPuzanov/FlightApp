//
//  Flight.swift
//  flight-demo
//
//  Created by Ivan Puzanov on 01.07.2026.
//

import Foundation

struct Flight: Equatable {
    let id: String
    let airline: Airline
    let origin: Airport
    let destination: Airport
    let departureDateTime: String
    let arrivalDateTime: String
    let price: Decimal
    let currency: String
    let baggage: Baggage
    let layovers: [Layover]
    let status: Status?

    init(from model: FlightResponseModel) {
        self.id = model.id
        self.airline = Airline(from: model.airline)
        self.origin = Airport(from: model.origin)
        self.destination = Airport(from: model.destination)
        self.departureDateTime = model.departureDateTime
        self.arrivalDateTime = model.arrivalDateTime
        self.price = model.price
        self.currency = model.currency
        self.baggage = Baggage(from: model.baggage)
        self.layovers = model.layovers.map { Layover(from: $0) }
        self.status = model.status.flatMap { Status(from: $0) }
    }
}

extension Flight {
    struct Airline: Equatable {
        let code: String
        let name: String
        let logo: String?

        init(from model: FlightResponseModel.AirlineResponseModel) {
            self.code = model.code
            self.name = model.name
            self.logo = model.logo
        }
    }

    struct Airport: Equatable {
        let iata: String
        let city: String
        let country: String

        init(from model: FlightResponseModel.AirportResponseModel) {
            self.iata = model.iata
            self.city = model.city
            self.country = model.country
        }
    }

    struct Baggage: Equatable {
        let cabinBaggageKg: Int
        let cabinBaggagePieces: Int
        let checkedBaggageKg: Int
        let checkedBaggagePieces: Int

        init(from model: FlightResponseModel.BaggageResponseModel) {
            self.cabinBaggageKg = model.cabinBaggageKg
            self.cabinBaggagePieces = model.cabinBaggagePieces
            self.checkedBaggageKg = model.checkedBaggageKg
            self.checkedBaggagePieces = model.checkedBaggagePieces
        }
    }

    struct Layover: Equatable {
        let airport: Airport
        let airline: Airline
        let departureDateTime: String

        init(from model: FlightResponseModel.LayoverResponseModel) {
            self.airport = Airport(from: model.airport)
            self.airline = Airline(from: model.airline)
            self.departureDateTime = model.departureDateTime
        }
    }

    enum Status: Equatable {
        case regular
        case recommended
        case bestPrice
        case fastest

        init(from model: FlightResponseModel.StatusResponseModel) {
            switch model {
            case .regular:
                self = .regular
            case .recommended:
                self = .recommended
            case .bestPrice:
                self = .bestPrice
            case .fastest:
                self = .fastest
            }
        }
    }
}
