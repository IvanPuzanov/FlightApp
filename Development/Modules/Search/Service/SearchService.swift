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

    func loadAirports() async -> Result<[Airport], any Error> {
        do {
            let airports = try await repository.fetchAirports()
            return .success(airports)
        } catch {
            return .failure(error)
        }
    }

    func loadFlights() async -> Result<[Flight], any Error> {
        do {
            let flights = try await repository.fetchFlights()
            return .success(flights)
        } catch {
            return .failure(error)
        }
    }
}
