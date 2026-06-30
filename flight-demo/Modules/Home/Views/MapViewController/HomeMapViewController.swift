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
    private let gradientView = GradientView()

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
        presenter.dispatch(.onViewDidLoad)
    }

    // MARK: - Private

    private func setupUI() {
        view.addSubviews(mapView, gradientView)
        view.backgroundColor = .systemBackground
        navigationController?.setNavigationBarHidden(true, animated: false)

        setupMapView()
        setupMapStyle()
        setupGradientView()
    }

    private func setupMapView() {
        mapView.delegate = self
        mapView.showsUserLocation = true

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

    private func setupGradientView() {
        gradientView.snp.makeConstraints {
            $0.height.equalTo(180)
            $0.leading.trailing.top.equalToSuperview()
        }
    }
}

// MARK: - MKMapViewDelegate

extension HomeMapViewController: MKMapViewDelegate {

    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
        presenter.dispatch(.onMapDidLoad)
    }
}

// MARK: - HomeViewControllerProtocol

extension HomeMapViewController: HomeMapModuleInputProtocol {

    func apply(_ state: HomeState.MapState) {
        moveToUserRegionIfNeeded(location: state.currentLocation)
    }

    private func moveToUserRegionIfNeeded(location: Coordinate?) {
        guard let location else { return }

        let region = MKCoordinateRegion(
            center: location.toCLLocationCoordinate2D,
            span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
        )
        mapView.setRegion(region, animated: true)
    }
}
