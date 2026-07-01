//
//  FlightResponseModel.swift
//  flight-demo
//
//  Created by Ivan Puzanov on 01.07.2026.
//

import Foundation

struct FlightResponseModel: Decodable {
    let flightNumber: String
    let airline: String
    let aircraft: String
    let originCity: String
    let originIata: String
    let destinationCity: String
    let destinationIata: String
}
