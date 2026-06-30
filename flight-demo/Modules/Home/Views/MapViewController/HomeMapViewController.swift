//
//  HomeMapViewController.swift
//  flight-demo
//
//  Created by Ivan Puzanov on 28.06.2026.
//

import MapKit
import SnapKit
import UIKit

protocol HomeMapModuleInputProtocol: ModuleInputProtocol where State == HomeState.MapState {}
protocol HomeMapModuleOutputProtocol: ModuleOutputProtocol where Event == HomeEvent.UIEvent {}

final class HomeMapViewController: UIViewController {

    // MARK: - Dependecies

    private let presenter: any HomeMapModuleOutputProtocol

    // MARK: - UI

    private let mapView = MKMapView()

    // MARK: - Initialization

    init(presenter: any HomeMapModuleOutputProtocol) {
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
    }

    // MARK: - Private

    private func setupUI() {
        view.addSubviews(mapView)
        view.backgroundColor = .systemBackground
        navigationController?.setNavigationBarHidden(true, animated: false)

        setupMapView()
        setupMapStyle()
    }

    private func setupMapView() {
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
}

// MARK: - MKMapViewDelegate

extension HomeMapViewController: MKMapViewDelegate {

    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
        presenter.dispatch(.map(.onMapDidLoad))
    }
}

// MARK: - HomeViewControllerProtocol

extension HomeMapViewController: HomeMapModuleInputProtocol {

    func apply(_ state: HomeState.MapState) {
        moveToUserRegionIfNeeded(state: state)
    }

    private func moveToUserRegionIfNeeded(state: HomeState.MapState) {
        guard
            !state.isDefaultRegionSet,
            let location = state.defaultRegionCoordinate
        else {
            return
        }

        let region = MKCoordinateRegion(
            center: location.toCLLocationCoordinate2D,
            span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
        )
        mapView.setRegion(region, animated: true)
        presenter.dispatch(.map(.onDefaultRegionSet))
    }
}
