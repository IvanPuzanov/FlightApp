//
//  HomeMapViewControllerAnnotationFactory.swift
//  flight-demo
//
//  Created by Ivan Puzanov on 07.07.2026.
//

import MapKit

private enum Constants {
    static let airplaneImage = UIImage(systemName: "airplane")
}

protocol HomeMapViewControllerFactoryProtocol {
    func createAnnotations(from airports: [Airport]) -> [AirportAnnotation]
    func createAnnotationView(mapView: MKMapView, annotation: AirportAnnotation) -> MKAnnotationView?
}

final class HomeMapViewControllerFactory: HomeMapViewControllerFactoryProtocol {

    // MARK: - Public

    func createAnnotations(from airports: [Airport]) -> [AirportAnnotation] {
        airports.map {
            AirportAnnotation(
                id: $0.id,
                coordinate: $0.location,
                configuration: createAirportMarkerViewConfiguration(
                    iata: $0.iata,
                    city: $0.city,
                    country: $0.country
                )
            )
        }
    }

    func createAnnotationView(mapView: MKMapView, annotation: AirportAnnotation) -> MKAnnotationView? {
        let annotationView = mapView.dequeueReusableAnnotationView(
            withIdentifier: AirportMarkerView.reuseIdentifier
        )
        annotationView?.image = createImage(from: annotation.configuration)
        annotationView?.annotation = annotation

        return annotationView
    }

    // MARK: - Private

    private func createAirportMarkerViewConfiguration(
        iata: String,
        city: String,
        country: String
    ) -> AirportMarkerViewConfiguration{
        AirportMarkerViewConfiguration(
            image: Constants.airplaneImage,
            iataLabelConfiguration: LabelConfiguration(
                text: iata,
                font: .boldSystemFont(ofSize: 14)
            ),
            countryLabelConfiguration: LabelConfiguration(
                text: "\(city), \(country)",
                font: .systemFont(ofSize: 14)
            )
        )
    }

    private func createImage(from configuration: AirportMarkerViewConfiguration) -> UIImage? {
        let markerView = AirportMarkerView()
        markerView.configure(with: configuration)
        return markerView.asImage()
    }
}
