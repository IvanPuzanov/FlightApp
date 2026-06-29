//
//  HomeMapViewController.swift
//  flight-demo
//
//  Created by Ivan Puzanov on 28.06.2026.
//

import MapKit
import SnapKit
import UIKit

protocol HomeMapViewControllerProtocol: AnyObject {
    func apply(state: HomeState.MapState)
}

final class HomeMapViewController: UIViewController {

    // MARK: - Dependecies

    private let presenter: HomePresenterProtocol
    private let configurationFactory: HomeMapConfigurationFactoryProtocol

    // MARK: - UI

    private let mapView = MKMapView()
    private let gradientView = GradientView()
    private let headerView = HomeHeaderView()
    private let bottomSheetViewController: HomeBottomSheetViewController

    // MARK: - Initialization

    init(
        presenter: HomePresenterProtocol,
        configurationFactory: HomeMapConfigurationFactoryProtocol,
        bottomSheetViewController: HomeBottomSheetViewController
    ) {
        self.presenter = presenter
        self.configurationFactory = configurationFactory
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
        view.addSubviews(mapView, gradientView, bottomSheetViewController.view, headerView)
        view.backgroundColor = .systemBackground
        navigationController?.setNavigationBarHidden(true, animated: false)

        setupMapView()
        setupMapStyle()
        setupGradientView()
        setupBottomSheet()
        setupHeaderView()
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

    private func setupBottomSheet() {
        addChild(bottomSheetViewController)
        bottomSheetViewController.didMove(toParent: self)

        bottomSheetViewController.view.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }

    private func setupHeaderView() {
        headerView
            .withBackgroundColor(.systemBackground)
            .withCornerRadius(30)
            .withShadow()

        headerView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(12)
            $0.leading.trailing.equalToSuperview().inset(16)
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

extension HomeMapViewController: HomeMapViewControllerProtocol {

    func apply(state: HomeState.MapState) {
        configureHeaderView(from: state.headerState)
        moveToUserRegionIfNeeded(location: state.currentLocation)
    }

    private func configureHeaderView(from state: HomeState.HeaderState) {
        let configuration = configurationFactory.makeHeaderViewConfiguration(from: state)
        headerView.configure(with: configuration)
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
