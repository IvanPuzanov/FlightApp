//
//  LocationManager.swift
//  flight-demo
//
//  Created by Ivan Puzanov on 28.06.2026.
//

import MapKit

enum LocationManagerError: Error {
    case permissionDenied
}

protocol LocationManagerProtocol: AnyObject {
    func getUserCurrentLocation() throws -> CLLocationCoordinate2D
}

final class LocationManager: LocationManagerProtocol {

    // MARK: - Dependencies

    private let manager = CLLocationManager()

    // MARK: - Public

    func getUserCurrentLocation() throws -> CLLocationCoordinate2D {
        let status = manager.authorizationStatus

        switch status {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            throw LocationManagerError.permissionDenied
        case .authorizedWhenInUse, .authorizedAlways:
            break
        @unknown default:
            break
        }

        return CLLocationCoordinate2D(latitude: 55.7520, longitude: 37.6175)
    }
}
