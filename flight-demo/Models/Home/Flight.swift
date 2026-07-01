//
//  Flight.swift
//  flight-demo
//
//  Created by Ivan Puzanov on 01.07.2026.
//

import Foundation

struct Flight {
    let flightNumber: String
    let airline: String
    let aircraft: String
    let originIata: String
    let destinationIata: String

    init(from model: FlightResponseModel) {
        self.flightNumber = model.flightNumber
        self.airline = model.airline
        self.aircraft = model.aircraft
        self.originIata = model.originIata
        self.destinationIata = model.destinationIata
    }
}
