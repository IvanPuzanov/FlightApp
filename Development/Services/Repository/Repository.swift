//
//  Repository.swift
//  flight-demo
//
//  Created by Ivan Puzanov on 01.07.2026.
//

import Foundation

final class Repository {

    // MARK: - Dependencies

    private let localDataSource: LocalDataSourceProtocol
    private let locationService: LocationServiceProtocol

    // MARK: - Initialization

    init(
        localDataSource: LocalDataSourceProtocol,
        locationService: LocationServiceProtocol
    ) {
        self.localDataSource = localDataSource
        self.locationService = locationService
    }
}

// MARK: - HomeRepositoryProtocol

extension Repository: HomeRepositoryProtocol {

    func getUserLocation(completion: (Result<Coordinate, any Error>) -> Void) {
        let coordinate = locationService.getDefaultLocation()
        completion(.success(coordinate))
    }

    func fetchAirports(completion: (Result<[Airport], any Error>) -> Void) {
        localDataSource.fetchAirports { result in
            switch result {
            case let .success(responseModels):
                let airports = responseModels.map { Airport(from: $0) }
                completion(.success(airports))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }

    func fetchFlights(completion: (Result<[Flight], any Error>) -> Void) {
        localDataSource.fetchFlight { result in
            switch result {
            case let .success(responseModels):
                let flights = responseModels.map { Flight(from: $0) }
                completion(.success(flights))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}
