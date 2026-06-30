//
//  HomeFlightListView.swift
//  flight-demo
//
//  Created by Ivan Puzanov on 30.06.2026.
//

import SnapKit
import UIKit

protocol HomeFlightListModuleInputProtocol: ModuleInputProtocol where State == HomeState.FlightListState {}
protocol HomeFlightListModuleOutputProtocol: ModuleOutputProtocol where Event == HomeEvent.UIEvent {}

final class HomeFlightListView: UIView {

    // MARK: - Typealiases

    private typealias Snapshot = NSDiffableDataSourceSnapshot<Int, String>
    private typealias DataSource = UITableViewDiffableDataSource<Int, String>

    // MARK: - Dependencies

    weak var bottomSheet: (any BottomSheetProtocol)?
    private let presenter: any HomeFlightListModuleOutputProtocol
    private let configurationFactory: HomeFlightListConfigurationFactoryProtocol

    // MARK: - UI

    private let grabberView = UIView()
    private let tableView = UITableView()

    // MARK: - Properties

    private var cellTypes: [String: HomeFlightListCellType] = [:]
    private lazy var dataSource = DataSource(tableView: tableView) { tableView, _, identifier in
        guard let cellType = self.cellTypes[identifier] else { return nil }

        switch cellType {
        case let .shimmer(cellConfiguration):
            let cell = tableView.dequeueReusableCell(with: cellConfiguration)
            return cell
        }
    }

    // MARK: - Initialization

    init(
        presenter: any HomeFlightListModuleOutputProtocol,
        configurationFactory: HomeFlightListConfigurationFactoryProtocol
    ) {
        self.presenter = presenter
        self.configurationFactory = configurationFactory
        super.init(frame: .zero)

        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private

    private func setupUI() {
        addSubviews(grabberView, tableView)
        withBackgroundColor(.Background.elevation1)
        withCornerRadius(44)
        withShadow()

        setupGrabberView()
        setupTableView()
    }

    private func setupGrabberView() {
        grabberView
            .withBackgroundColor(.separator)
            .withCornerRadius(3)

        grabberView.snp.makeConstraints {
            $0.width.equalTo(50)
            $0.height.equalTo(6)
            $0.top.equalToSuperview().inset(12)
            $0.centerX.equalToSuperview()
        }
    }

    private func setupTableView() {
        tableView.isScrollEnabled = false
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none

        tableView.snp.makeConstraints {
            $0.top.equalTo(grabberView.snp.bottom).offset(10)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}

// MARK: - BottomSheetContentViewProtocol

extension HomeFlightListView: BottomSheetContentViewProtocol {

    func dispatch(_ event: BottomSheetEvent) {
        switch event {
        case let .onProgressDidChange(progress):
            presenter.dispatch(.flightList(.onBottomSheetHeightChange(progress: progress)))
        }
    }
}

// MARK: - FlightListModuleProtocol

extension HomeFlightListView: HomeFlightListModuleInputProtocol {

    func apply(_ state: HomeState.FlightListState) {
        configureAppearance(with: state.appearance)
        renderTableView(from: state.contentState)
    }

    private func configureAppearance(with appearance: HomeState.FlightListState.Appearance) {
        bottomSheet?.setupDetents(appearance.bottomSheetDetents)
        layer.shadowOpacity = appearance.isGrabberHidden ? 0 : 0.1
    }

    private func renderTableView(from state: HomeState.FlightListState.ContentState) {
        let newCellTypes = configurationFactory.createFlightListCellTypes(from: state)
        let ids = newCellTypes.compactMap { $0.id }

        cellTypes = Dictionary(uniqueKeysWithValues: zip(ids, newCellTypes))

        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(ids, toSection: 0)
        dataSource.apply(snapshot)
    }
}
