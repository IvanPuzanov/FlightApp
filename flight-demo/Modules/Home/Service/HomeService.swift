//
//  HomeService.swift
//  flight-demo
//
//  Created by Ivan Puzanov on 28.06.2026.
//

import Combine

protocol HomeServiceProtocol: AnyObject {
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

    func loadAirports() -> AnyPublisher<[Airport], any Error> {
        Future { [weak repository] promise in
            repository?.fetchAirports(completion: promise)
        }.eraseToAnyPublisher()
    }

    func loadFlights() -> AnyPublisher<[Flight], any Error> {
        Future { [weak repository] promise in
            repository?.fetchFlights(completion: promise)
        }.eraseToAnyPublisher()
    }
}
