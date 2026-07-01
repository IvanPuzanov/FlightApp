//
//  Airport.swift
//  flight-demo
//
//  Created by Ivan Puzanov on 01.07.2026.
//

import Foundation

struct Airport {
    let iata: String

    init(from model: AirportResponseModel) {
        self.iata = model.iata
    }
}
