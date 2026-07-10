//
//  Repository.swift
//  flight-demo
//
//  Created by Ivan Puzanov on 01.07.2026.
//

import Foundation

final class Repository {

    // MARK: - Dependencies

    private let remoteDataSource: RemoteDataSourceProtocol
    private let locationService: LocationServiceProtocol

    // MARK: - Initialization

    init(
        remoteDataSource: RemoteDataSourceProtocol,
        locationService: LocationServiceProtocol
    ) {
        self.remoteDataSource = remoteDataSource
        self.locationService = locationService
    }
}

// MARK: - SearchRepositoryProtocol

extension Repository: SearchRepositoryProtocol {

    func getUserLocation(completion: (Result<Coordinate, any Error>) -> Void) {
        let coordinate = locationService.getDefaultLocation()
        completion(.success(coordinate))
    }

    func fetchAirports() async throws -> [Airport] {
        let result = try await remoteDataSource.fetchAirports()

        switch result {
        case let .success(responseModel):
            return responseModel.map { Airport(from: $0) }
        case let .failure(error):
            throw error
        }
    }

    func fetchFlights() async throws -> [Flight] {
        let result = try await remoteDataSource.fetchFlights()

        switch result {
        case let .success(responseModel):
            return responseModel.map { Flight(from: $0) }
        case let .failure(error):
            throw error
        }
    }
}
