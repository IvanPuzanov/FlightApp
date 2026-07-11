//
//  LocationServiceMock.swift
//  FlightDemoApp
//
//  Created by Ivan Puzanov on 10.07.2026.
//

import Foundation
@testable import FlightDemoApp

final class LocationServiceMock: LocationServiceProtocol {

    // MARK: - getDefaultLocation

    var invokedGetDefaultLocation = false
    var invokedGetDefaultLocationCallsCount = 0
    var stubbedGetDefaultLocationResult = Coordinate.fake(latitude: 48.8566, longitude: 2.3522)

    func getDefaultLocation() -> Coordinate {
        invokedGetDefaultLocation = true
        invokedGetDefaultLocationCallsCount += 1
        return stubbedGetDefaultLocationResult
    }

    // MARK: - getUserCurrentLocation

    var invokedGetUserCurrentLocation = false
    var invokedGetUserCurrentLocationCallsCount = 0
    var stubbedGetUserCurrentLocationResult = Coordinate.fake(latitude: 48.8566, longitude: 2.3522)
    var stubbedGetUserCurrentLocationError: Error?

    func getUserCurrentLocation() throws -> Coordinate {
        invokedGetUserCurrentLocation = true
        invokedGetUserCurrentLocationCallsCount += 1

        if let stubbedGetUserCurrentLocationError {
            throw stubbedGetUserCurrentLocationError
        }

        return stubbedGetUserCurrentLocationResult
    }
}
