//
//  SearchMapViewController.swift
//  flight-demo
//
//  Created by Ivan Puzanov on 28.06.2026.
//

import Combine
import MapKit
import SnapKit
import UIKit

final class SearchMapViewController: UIViewController {

    // MARK: - Dependecies

    private let store: SearchStoreProtocol
    private let factory: SearchMapViewControllerFactoryProtocol

    // MARK: - UI

    private let mapView = MKMapView()

    // MARK: - Properties

    private var bag: Set<AnyCancellable> = []

    // MARK: - Initialization

    init(
        store: SearchStoreProtocol,
        factory: SearchMapViewControllerFactoryProtocol
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
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                self?.apply(state)
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
        mapView.register(
            AirportMarkerView.self,
            forAnnotationViewWithReuseIdentifier: AirportMarkerView.reuseIdentifier
        )
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

    private func apply(_ state: SearchState.MapState) {
        moveToUserRegionIfNeeded(state: state)

        let airportAnnotations = factory.createAnnotations(from: state.airports)
        mapView.addAnnotations(airportAnnotations)
    }
}

// MARK: - MKMapViewDelegate

extension SearchMapViewController: MKMapViewDelegate {

    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
        store.dispatch(event: .ui(.map(.onMapDidLoad)))
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: any MKAnnotation) -> MKAnnotationView? {
        guard let airportAnnotation = annotation as? AirportAnnotation else { return nil }

        return factory.createAnnotationView(mapView: mapView, annotation: airportAnnotation)
    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotation = view.annotation as? AirportAnnotation else { return }

        let airportId = annotation.id
        store.dispatch(event: .ui(.map(.onAirportSelect(id: airportId))))
    }
}

// MARK: - SearchViewControllerProtocol

extension SearchMapViewController {

    private func moveToUserRegionIfNeeded(state: SearchState.MapState) {
        guard let location = state.defaultRegionCoordinate else { return }

        let region = MKCoordinateRegion(
            center: location.toCLLocationCoordinate2D,
            span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
        )
        mapView.setRegion(region, animated: true)
    }
}
