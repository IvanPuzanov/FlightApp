//
//  HomeRepositoryProtocol.swift
//  flight-demo
//
//  Created by Ivan Puzanov on 01.07.2026.
//

import Foundation

protocol HomeRepositoryProtocol: AnyObject {
    func getUserLocation(completion: (Result<Coordinate, Error>) -> Void)
    func fetchAirports(completion: (Result<[Airport], Error>) -> Void)
    func fetchFlights(completion: (Result<[Flight], Error>) -> Void)
}
