//
//  SearchServiceMock.swift
//  FlightDemoApp
//
//  Created by Ivan Puzanov on 10.07.2026.
//

import Combine
import Foundation
@testable import FlightDemoApp

final class SearchServiceMock: SearchServiceProtocol {

    // MARK: - getDefaultLocation

    var invokedGetDefaultLocation = false
    var invokedGetDefaultLocationCallsCount = 0
    var stubbedGetDefaultLocationResult: AnyPublisher<Coordinate, Error> = Empty().eraseToAnyPublisher()

    func getDefaultLocation() -> AnyPublisher<Coordinate, any Error> {
        invokedGetDefaultLocation = true
        invokedGetDefaultLocationCallsCount += 1
        return stubbedGetDefaultLocationResult
    }

    // MARK: - loadAirports

    var invokedLoadAirports = false
    var invokedLoadAirportsCallsCount = 0
    var stubbedLoadAirportsResult: Result<[Airport], Error> = .success([])

    func loadAirports() async -> Result<[Airport], any Error> {
        invokedLoadAirports = true
        invokedLoadAirportsCallsCount += 1
        return stubbedLoadAirportsResult
    }

    // MARK: - loadFlights

    var invokedLoadFlights = false
    var invokedLoadFlightsCallsCount = 0
    var stubbedLoadFlightsResult: Result<[Flight], Error> = .success([])

    func loadFlights() async -> Result<[Flight], any Error> {
        invokedLoadFlights = true
        invokedLoadFlightsCallsCount += 1
        return stubbedLoadFlightsResult
    }
}
