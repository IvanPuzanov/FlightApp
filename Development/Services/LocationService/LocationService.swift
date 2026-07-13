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

protocol LocationServiceProtocol: AnyObject {
    func getDefaultLocation() -> Coordinate
    func getUserCurrentLocation() -> Result<Coordinate, Error>
}

final class LocationService: LocationServiceProtocol {

    // MARK: - Dependencies

    private let manager = CLLocationManager()

    // MARK: - Public

    func getDefaultLocation() -> Coordinate {
        return Constants.defaultCoordinate
    }

    func getUserCurrentLocation() -> Result<Coordinate, Error> {
        let status = manager.authorizationStatus

        switch status {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            return .failure(NSError())
        case .authorizedWhenInUse, .authorizedAlways:
            break
        @unknown default:
            break
        }

        return .success(Constants.defaultCoordinate)
    }
}
