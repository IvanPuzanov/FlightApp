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

    func fetchAirports() async -> Result<[Airport], Error> {
        let result = await remoteDataSource.fetchAirports()

        switch result {
        case let .success(responseModel):
            let airports = responseModel.map { Airport(from: $0) }
            return .success(airports)
        case let .failure(error):
            return .failure(error)
        }
    }

    func fetchFlights() async -> Result<[Flight], Error> {
        let result = await remoteDataSource.fetchFlights()

        switch result {
        case let .success(responseModel):
            let flights = responseModel.map { Flight(from: $0) }
            return .success(flights)
        case let .failure(error):
            return .failure(error)
        }
    }
}
