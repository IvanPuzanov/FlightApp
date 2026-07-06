//
//  LocationService.swift
//  flight-demo
//
//  Created by Ivan Puzanov on 28.06.2026.
//

import MapKit

private enum Constants {
    static let defaultCoordinate = Coordinate(latitude: 48.8566, longitude: 2.3522)
}

enum LocationServiceError: Error {
    case permissionDenied
}

protocol LocationServiceProtocol: AnyObject {
    func getDefaultLocation() -> Coordinate
    func getUserCurrentLocation() throws -> Coordinate
}

final class LocationService: LocationServiceProtocol {

    // MARK: - Dependencies

    private let manager = CLLocationManager()

    // MARK: - Public

    func getDefaultLocation() -> Coordinate {
        return Constants.defaultCoordinate
    }

    func getUserCurrentLocation() throws -> Coordinate {
        let status = manager.authorizationStatus

        switch status {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            throw LocationServiceError.permissionDenied
        case .authorizedWhenInUse, .authorizedAlways:
            break
        @unknown default:
            break
        }

        return Coordinate(latitude: 55.7520, longitude: 37.6175)
    }
}
