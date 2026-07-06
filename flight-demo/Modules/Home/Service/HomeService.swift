//
//  HomeService.swift
//  flight-demo
//
//  Created by Ivan Puzanov on 28.06.2026.
//

import Combine

protocol HomeServiceProtocol: AnyObject {
    func getDefaultLocation() -> AnyPublisher<Coordinate, Error>
    func loadAirports() -> AnyPublisher<[Airport], Error>
    func loadFlights() -> AnyPublisher<[Flight], Error>
}

final class HomeService: HomeServiceProtocol {

    // MARK: - Dependencies

    private let repository: HomeRepositoryProtocol

    // MARK: - Initialization

    init(repository: HomeRepositoryProtocol) {
        self.repository = repository
    }

    // MARK: - Public

    func getDefaultLocation() -> AnyPublisher<Coordinate, Error> {
        Future { [weak repository] promise in
            repository?.getUserLocation(completion: promise)
        }.eraseToAnyPublisher()
    }

    func loadAirports() -> AnyPublisher<[Airport], Error> {
        Future { [weak repository] promise in
            repository?.fetchAirports(completion: promise)
        }.eraseToAnyPublisher()
    }

    func loadFlights() -> AnyPublisher<[Flight], Error> {
        Future { [weak repository] promise in
            repository?.fetchFlights(completion: promise)
        }.eraseToAnyPublisher()
    }
}
