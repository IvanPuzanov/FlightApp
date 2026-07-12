//
//  FlightResponseModel.swift
//  flight-demo
//
//  Created by Ivan Puzanov on 01.07.2026.
//

import Foundation

struct FlightResponseModel: Decodable {
    let id: String
    let airline: AirlineResponseModel
    let origin: AirportResponseModel
    let destination: AirportResponseModel
    let departureDateTime: String
    let arrivalDateTime: String
    let price: Decimal
    let currency: String
    let baggage: BaggageResponseModel
    let layovers: [LayoverResponseModel]
    let status: StatusResponseModel?
}

extension FlightResponseModel {
    struct AirlineResponseModel: Decodable {
        let code: String
        let name: String
        let logo: String?
    }

    struct AirportResponseModel: Decodable {
        let iata: String
        let city: String
        let country: String
    }

    struct BaggageResponseModel: Decodable {
        let cabinBaggageKg: Int
        let cabinBaggagePieces: Int
        let checkedBaggageKg: Int
        let checkedBaggagePieces: Int
    }

    struct LayoverResponseModel: Decodable {
        let airport: FlightResponseModel.AirportResponseModel
        let airline: FlightResponseModel.AirlineResponseModel
        let departureDateTime: String
    }

    enum StatusResponseModel: String, Decodable {
        case regular
        case recommended
        case bestPrice = "best_price"
        case fastest

        init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            let rawValue = try container.decode(String.self)
            self = StatusResponseModel(rawValue: rawValue) ?? .regular
        }
    }
}
