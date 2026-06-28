//
//  HomeMapViewController.swift
//  flight-demo
//
//  Created by Ivan Puzanov on 28.06.2026.
//

import MapKit
import UIKit

protocol HomeMapViewControllerProtocol: AnyObject {
    func apply(state: HomeState.MapState)
}

final class HomeMapViewController: UIViewController {

    // MARK: - Dependecies

    private let presenter: HomePresenterProtocol

    // MARK: - UI

    private let mapView = MKMapView()
    private let bottomSheetViewController: HomeBottomSheetViewController

    // MARK: - Initialization

    init(
        presenter: HomePresenterProtocol,
        bottomSheetViewController: HomeBottomSheetViewController
    ) {
        self.presenter = presenter
        self.bottomSheetViewController = bottomSheetViewController
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
        setupBottomSheet()
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

    private func setupBottomSheet() {
        addChild(bottomSheetViewController)
        view.addSubview(bottomSheetViewController.view)
        bottomSheetViewController.didMove(toParent: self)
        bottomSheetViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            bottomSheetViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomSheetViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomSheetViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - MKMapViewDelegate

extension HomeMapViewController: MKMapViewDelegate {

    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
        presenter.dispatch(.onMapDidLoad)
    }
}

// MARK: - HomeViewControllerProtocol

extension HomeMapViewController: HomeMapViewControllerProtocol {

    func apply(state: HomeState.MapState) {
        moveToUserRegionIfNeeded(location: state.currentLocation)
    }

    private func moveToUserRegionIfNeeded(location: Coordinate?) {
        guard let location else { return }

        let region = MKCoordinateRegion(
            center: location.toCLLocationCoordinate2D,
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        )
        mapView.setRegion(region, animated: true)
    }
}
