//
//  RemoteDataSource.swift
//  FlightDemoApp
//
//  Created by Ivan Puzanov on 10.07.2026.
//

import Foundation

protocol RemoteDataSourceProtocol: AnyObject {
    func fetchAirports() async -> Result<[AirportResponseModel], Error>
    func fetchFlights() async -> Result<[FlightResponseModel], Error>
}

final class RemoteDataSource: RemoteDataSourceProtocol {

    // MARK: - Dependencies

    private let networkService: NetworkServiceProtocol

    // MARK: - Properties

    private let baseURL: URL

    // MARK: - Initialization

    init(
        baseURL: URL,
        networkService: NetworkServiceProtocol
    ) {
        self.baseURL = baseURL
        self.networkService = networkService
    }

    // MARK: - Public

    func fetchAirports() async -> Result<[AirportResponseModel], any Error> {
        let request = RemoteTarget.fetchAirports(baseURL: baseURL)
        let result = await networkService.sendRequest(
            request: request,
            responseModel: [AirportResponseModel].self
        )

        return result
    }

    func fetchFlights() async -> Result<[FlightResponseModel], Error> {
        let request = RemoteTarget.fetchFlights(baseURL: baseURL)
        let result = await networkService.sendRequest(
            request: request,
            responseModel: [FlightResponseModel].self
        )

        return result
    }
}

