//
//  AirportResponseModel.swift
//  flight-demo
//
//  Created by Ivan Puzanov on 01.07.2026.
//

import Foundation

struct AirportResponseModel: Decodable {
    let id: Int
    let iata: String
    let city: String
    let country: String
    let lat: Double
    let lon: Double
}
