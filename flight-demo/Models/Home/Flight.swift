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
    let aircraft: String
    let originCity: String
    let originIata: String
    let destinationCity: String
    let destinationIata: String

    init(from model: FlightResponseModel) {
        self.flightNumber = model.flightNumber
        self.airline = model.airline
        self.aircraft = model.aircraft
        self.originCity = model.originCity
        self.originIata = model.originIata
        self.destinationCity = model.destinationCity
        self.destinationIata = model.destinationIata
    }
}
