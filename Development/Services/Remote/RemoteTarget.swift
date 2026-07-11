//
//  RemoteTarget.swift
//  FlightDemoApp
//
//  Created by Ivan Puzanov on 10.07.2026.
//

import Foundation

enum RemoteTarget {
    static func fetchAirports(baseURL: URL) -> APIRequest {
        APIRequest(
            baseURL: baseURL,
            path: RemoteTarget.airports
        )
    }
    static func fetchFlights(baseURL: URL) -> APIRequest {
        APIRequest(
            baseURL: baseURL,
            path: RemoteTarget.flights
        )
    }
}

extension RemoteTarget {
    static let airports = "airports.json"
    static let flights = "flights.json"
}
