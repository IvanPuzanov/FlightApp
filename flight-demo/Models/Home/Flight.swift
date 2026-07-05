//
//  Flight.swift
//  flight-demo
//
//  Created by Ivan Puzanov on 01.07.2026.
//

import Foundation

struct Flight: Equatable {
    let flightNumber: String
    let airline: String
    let airlineCode: String
    let aircraft: String
    let originCity: String
    let originIata: String
    let destinationCity: String
    let destinationIata: String
    let status: FlightStatus

    init(from model: FlightResponseModel) {
        self.flightNumber = model.flightNumber
        self.airline = model.airline
        self.airlineCode = model.airlineCode
        self.aircraft = model.aircraft
        self.originCity = model.originCity
        self.originIata = model.originIata
        self.destinationCity = model.destinationCity
        self.destinationIata = model.destinationIata
        self.status = FlightStatus(from: model.status)
    }
}

extension Flight {

    enum FlightStatus {
        case boarding
        case inAir
        case delayed
        case landed
        case cancelled

        init(from modelStatus: FlightResponseModel.FlightStatus) {
            switch modelStatus {
            case .boarding:
                self = .boarding
            case .inAir:
                self = .inAir
            case .delayed:
                self = .delayed
            case .landed:
                self = .landed
            case .cancelled:
                self = .cancelled
            }
        }
    }
}
