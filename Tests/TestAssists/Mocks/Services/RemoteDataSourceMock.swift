//
//  RemoteDataSourceMock.swift
//  FlightDemoApp
//
//  Created by Ivan Puzanov on 10.07.2026.
//

import Foundation
@testable import FlightDemoApp

final class RemoteDataSourceMock: RemoteDataSourceProtocol {

    // MARK: - fetchAirports

    var invokedFetchAirports = false
    var invokedFetchAirportsCallsCount = 0
    var stubbedFetchAirportsResult: Result<[AirportResponseModel], Error> = .success([])

    func fetchAirports() async -> Result<[AirportResponseModel], any Error> {
        invokedFetchAirports = true
        invokedFetchAirportsCallsCount += 1

        return stubbedFetchAirportsResult
    }

    // MARK: - fetchFlights

    var invokedFetchFlights = false
    var invokedFetchFlightsCallsCount = 0
    var stubbedFetchFlightsResult: Result<[FlightResponseModel], Error> = .success([])

    func fetchFlights() async -> Result<[FlightResponseModel], any Error> {
        invokedFetchFlights = true
        invokedFetchFlightsCallsCount += 1

        return stubbedFetchFlightsResult
    }
}
