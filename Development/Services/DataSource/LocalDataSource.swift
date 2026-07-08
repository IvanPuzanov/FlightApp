//
//  LocalDataSource.swift
//  flight-demo
//
//  Created by Ivan Puzanov on 01.07.2026.
//

import Foundation

protocol LocalDataSourceProtocol {
    func fetchAirports(completion: (Result<[AirportResponseModel], Error>) -> Void)
    func fetchFlight(completion: (Result<[FlightResponseModel], Error>) -> Void)
}

final class LocalDataSource: LocalDataSourceProtocol {

    // MARK: - Dependecies

    private let localStorageService: LocalStorageServiceProtocol

    // MARK: - Initialization

    init(localStorageService: LocalStorageServiceProtocol) {
        self.localStorageService = localStorageService
    }

    // MARK: - Public

    func fetchAirports(completion: (Result<[AirportResponseModel], Error>) -> Void) {
        localStorageService.fetchData(
            ofType: [AirportResponseModel].self,
            fileName: .airports,
            completion: completion
        )
    }
    
    func fetchFlight(completion: (Result<[FlightResponseModel], any Error>) -> Void) {
        localStorageService.fetchData(
            ofType: [FlightResponseModel].self,
            fileName: .flights,
            completion: completion
        )
    }
}
