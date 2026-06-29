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
    var isSearch = true

    // MARK: - UI

    private let mapView = MKMapView()
    private let gradientView = GradientView()
    private let headerView = HomeHeaderView()
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
    }

    private func setupGradientView() {
        gradientView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            gradientView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            gradientView.topAnchor.constraint(equalTo: view.topAnchor),
            gradientView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            gradientView.heightAnchor.constraint(equalToConstant: 180)
        ])
    }

    private func setupBottomSheet() {
        addChild(bottomSheetViewController)
        bottomSheetViewController.didMove(toParent: self)
        bottomSheetViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            bottomSheetViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomSheetViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomSheetViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func setupHeaderView() {
        headerView
            .withBackgroundColor(.systemBackground)
            .withCornerRadius(30)
            .withShadow()
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.configure(
            with: HomeHeaderViewConfiguration(
                mode: .search(
                    HomeHeaderViewConfiguration.SearchModel(
                        leadingIcon: UIImage(systemName: "magnifyingglass") ?? UIImage(),
                        placeholderText: "Search flight or aircraft",
                        trailingIcon: UIImage(systemName: "slider.horizontal.3") ?? UIImage()
                    )
                )
            )
        )

        NSLayoutConstraint.activate([
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12)
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
            span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
        )
        mapView.setRegion(region, animated: true)
    }
}
