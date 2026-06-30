//
//  HomeViewController.swift
//  flight-demo
//
//  Created by Ivan Puzanov on 30.06.2026.
//

import SnapKit
import UIKit

protocol HomeViewModuleOutputProtocol: ModuleOutputProtocol where Event == HomeEvent.UIEvent {}

final class HomeViewController: UIViewController {

    // MARK: - Dependencies

    private let presenter: any HomeViewModuleOutputProtocol

    // MARK: - UI

    private let headerView: HomeHeaderView
    private let mapViewController: UIViewController
    private let flightListBottomSheet: UIViewController

    // MARK: - Initialization

    init(
        presenter: any HomeViewModuleOutputProtocol,
        headerView: HomeHeaderView,
        mapViewController: UIViewController,
        flightListBottomSheet: UIViewController
    ) {
        self.presenter = presenter
        self.headerView = headerView
        self.mapViewController = mapViewController
        self.flightListBottomSheet = flightListBottomSheet
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        presenter.dispatch(.common(.onViewDidLoad))
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        let maxHeight = view.frame.height - view.safeAreaInsets.top - 10
        presenter.dispatch(.common(.onCalculateFlightListMaxHeight(maxHeight)))
    }

    // MARK: - Private

    private func setupUI() {
        navigationController?.setNavigationBarHidden(true, animated: false)
        view.addSubviews(mapViewController.view, flightListBottomSheet.view, headerView)

        setupMapViewController()
        setupFlightListBottomSheet()
        setupHeaderView()
    }

    private func setupMapViewController() {
        addChild(mapViewController)
        mapViewController.didMove(toParent: self)

        mapViewController.view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    private func setupFlightListBottomSheet() {
        addChild(flightListBottomSheet)
        flightListBottomSheet.didMove(toParent: self)

        flightListBottomSheet.view.snp.makeConstraints {
            $0.leading.bottom.trailing.equalToSuperview()
        }
    }

    private func setupHeaderView() {
        headerView.snp.makeConstraints {
            $0.leading.trailing.top.equalToSuperview()
        }
    }
}
