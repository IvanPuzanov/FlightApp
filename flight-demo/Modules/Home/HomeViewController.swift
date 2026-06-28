//
//  HomeViewController.swift
//  flight-demo
//
//  Created by Ivan Puzanov on 28.06.2026.
//

import MapKit
import UIKit

protocol HomeViewControllerProtocol: AnyObject {
    func apply(state: HomeState.MapState)
}

final class HomeViewController: UIViewController {

    // MARK: - Dependecies

    private let presenter: HomePresenterProtocol

    // MARK: - UI

    private let mapView = MKMapView()

    // MARK: - Initialization

    init(presenter: HomePresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        presenter.dispatch(.onViewDidLoad)
    }

    // MARK: - Private

    private func setupUI() {
        view.addSubviews(mapView)
        view.backgroundColor = .systemBackground

        setupMapView()
        setupMapStyle()
    }

    private func setupMapView() {
        mapView.delegate = self
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.showsUserLocation = true

        NSLayoutConstraint.activate([
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func setupMapStyle() {
        let configuration = MKStandardMapConfiguration()
        configuration.elevationStyle = .flat
        configuration.emphasisStyle = .muted
        configuration.pointOfInterestFilter = .excludingAll
        configuration.showsTraffic = false

        mapView.preferredConfiguration = configuration
        mapView.overrideUserInterfaceStyle = .dark
    }
}

// MARK: - MKMapViewDelegate

extension HomeViewController: MKMapViewDelegate {

    func mapViewDidFinishRenderingMap(_ mapView: MKMapView, fullyRendered: Bool) {
        presenter.dispatch(.onMapFullyRendered)
    }
}

// MARK: - HomeViewControllerProtocol

extension HomeViewController: HomeViewControllerProtocol {

    func apply(state: HomeState.MapState) {
        moveToUserRegionIfNeeded(location: state.currentLocation)
    }

    private func moveToUserRegionIfNeeded(location: CLLocationCoordinate2D?) {
        guard let location else { return }

        let region = MKCoordinateRegion(
            center: location,
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        )
        mapView.setRegion(region, animated: true)
    }
}
