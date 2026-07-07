//
//  HomeMapViewController.swift
//  flight-demo
//
//  Created by Ivan Puzanov on 28.06.2026.
//

import Combine
import MapKit
import SnapKit
import UIKit

final class HomeMapViewController: UIViewController {

    // MARK: - Dependecies

    private let store: HomeStoreProtocol
    private let factory: HomeMapViewControllerFactoryProtocol

    // MARK: - UI

    private let mapView = MKMapView()

    // MARK: - Properties

    private var bag: Set<AnyCancellable> = []

    // MARK: - Initialization

    init(
        store: HomeStoreProtocol,
        factory: HomeMapViewControllerFactoryProtocol
    ) {
        self.store = store
        self.factory = factory
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupBindings()
        setupUI()
    }

    // MARK: - Private

    private func setupBindings() {
        store.stateDidChange
            .compactMap { [weak store] in
                store?.state.mapState
            }
            .removeDuplicates()
            .sink { state in
                self.apply(state)
            }.store(in: &bag)
    }

    private func setupUI() {
        view.addSubviews(mapView)
        view.backgroundColor = .systemBackground
        navigationController?.setNavigationBarHidden(true, animated: false)

        setupMapView()
        setupMapStyle()
    }

    private func setupMapView() {
        let reuseIdentifier = NSStringFromClass(AirportMarkerView.self)
        mapView.register(AirportMarkerView.self, forAnnotationViewWithReuseIdentifier: reuseIdentifier)
        mapView.delegate = self

        mapView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    private func setupMapStyle() {
        let configuration = MKStandardMapConfiguration()
        configuration.elevationStyle = .flat
        configuration.emphasisStyle = .muted
        configuration.pointOfInterestFilter = .excludingAll
        configuration.showsTraffic = false

        mapView.preferredConfiguration = configuration
    }

    private func apply(_ state: HomeState.MapState) {
        moveToUserRegionIfNeeded(state: state)

        let airportAnnotations = factory.createAnnotations(from: state.airports)
        mapView.addAnnotations(airportAnnotations)
    }
}

// MARK: - MKMapViewDelegate

extension HomeMapViewController: MKMapViewDelegate {

    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
        store.dispatch(event: .ui(.map(.onMapDidLoad)))
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: any MKAnnotation) -> MKAnnotationView? {
        guard let airportAnnotation = annotation as? AirportAnnotation else { return nil }

        let reuseIdentifier = NSStringFromClass(AirportMarkerView.self)
        let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
        annotationView?.image = factory.createImage(from: airportAnnotation.configuration)
        annotationView?.annotation = airportAnnotation

        return annotationView
    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotation = view.annotation as? AirportAnnotation else { return }

        let airportId = annotation.id
        store.dispatch(event: .ui(.map(.onAirportSelect(id: airportId))))
    }
}

// MARK: - HomeViewControllerProtocol

extension HomeMapViewController {

    private func moveToUserRegionIfNeeded(state: HomeState.MapState) {
        guard let location = state.defaultRegionCoordinate else { return }

        let region = MKCoordinateRegion(
            center: location.toCLLocationCoordinate2D,
            span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
        )
        mapView.setRegion(region, animated: true)
    }
}
