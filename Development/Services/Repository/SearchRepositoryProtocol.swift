//
//  SearchRepositoryProtocol.swift
//  flight-demo
//
//  Created by Ivan Puzanov on 01.07.2026.
//

import Foundation

protocol SearchRepositoryProtocol: AnyObject {
    func getUserLocation(completion: (Result<Coordinate, Error>) -> Void)
    func fetchAirports() async throws -> [Airport]
    func fetchFlights() async throws -> [Flight]
}
