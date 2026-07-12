//
//  SearchService.swift
//  flight-demo
//
//  Created by Ivan Puzanov on 28.06.2026.
//

import Combine

protocol SearchServiceProtocol: AnyObject {
    func getDefaultLocation() -> AnyPublisher<Coordinate, Error>
    func loadAirports() async -> Result<[Airport], Error>
    func loadFlights() async -> Result<[Flight], Error>
}

final class SearchService: SearchServiceProtocol {

    // MARK: - Dependencies

    private let repository: SearchRepositoryProtocol

    // MARK: - Initialization

    init(repository: SearchRepositoryProtocol) {
        self.repository = repository
    }

    // MARK: - Public

    func getDefaultLocation() -> AnyPublisher<Coordinate, Error> {
        Future { [weak repository] promise in
            repository?.getUserLocation(completion: promise)
        }.eraseToAnyPublisher()
    }

    func loadAirports() async -> Result<[Airport], Error> {
        let airportsResult = await repository.fetchAirports()
        return airportsResult
    }

    func loadFlights() async -> Result<[Flight], Error> {
        let flightsResult = await repository.fetchFlights()
        return flightsResult
    }
}
