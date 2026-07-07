//
//  HomeFlightListView.swift
//  flight-demo
//
//  Created by Ivan Puzanov on 30.06.2026.
//

import Combine
import SnapKit
import UIKit

private enum Constants {
    static let defaultDetents: [HomeState.FlightListState.BottomSheetDetent] = [
        HomeState.FlightListState.BottomSheetDetent(id: .compact, height: 200),
        HomeState.FlightListState.BottomSheetDetent(id: .compact, height: 520)
    ]
    static let cornerRadius: CGFloat = 30
    static let shadowOpacity: Float = 0.1
}

final class HomeFlightListView: UIView {

    // MARK: - Typealiases

    private typealias Snapshot = NSDiffableDataSourceSnapshot<Int, String>
    private typealias DataSource = UITableViewDiffableDataSource<Int, String>

    // MARK: - Dependencies

    weak var bottomSheet: (any BottomSheetProtocol)?
    private let store: HomeStoreProtocol
    private let configurationFactory: HomeFlightListConfigurationFactoryProtocol

    // MARK: - UI

    private let grabberView = UIView()
    private let statusView = StatusView()
    private let tableView = UITableView()
    private let mapButton = HomeFlightListMapButton()

    // MARK: - Properties

    private var bag: Set<AnyCancellable> = []
    private var mapButtonBottomConstraint: Constraint?

    // MARK: - Properties

    private var cellTypes: [String: HomeFlightListCellType] = [:]
    private lazy var dataSource = DataSource(tableView: tableView) { tableView, _, identifier in
        guard let cellType = self.cellTypes[identifier] else { return nil }

        switch cellType {
        case let .shimmer(cellConfiguration):
            let cell = tableView.dequeueReusableCell(with: cellConfiguration)
            return cell
        case let .flight(cellConfiguration):
            let cell = tableView.dequeueReusableCell(with: cellConfiguration)
            return cell
        }
    }

    // MARK: - Initialization

    init(
        store: HomeStoreProtocol,
        configurationFactory: HomeFlightListConfigurationFactoryProtocol
    ) {
        self.store = store
        self.configurationFactory = configurationFactory
        super.init(frame: .zero)

        setupBindings()
        setupUI()

        store.dispatch(event: .ui(.flightList(.onSetup(
            cornerRadius: Constants.cornerRadius,
            shadowOpacity: Constants.shadowOpacity,
            detents: Constants.defaultDetents)))
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private

    private func setupBindings() {
        store.stateDidChange
            .compactMap { [weak store] in
                store?.state.flightListState
            }
            .removeDuplicates()
            .sink { state in
                self.apply(state)
            }.store(in: &bag)

        store.stateDidChange
            .compactMap { [weak store] in
                store?.state.flightListState.bottomSheetState
            }
            .removeDuplicates()
            .sink { [weak self] state in
                self?.bottomSheet?.setupDetents(state.detents.map { $0.height })
                self?.bottomSheet?.setDetent(state.currentDetent.height)
            }.store(in: &bag)
    }

    private func setupUI() {
        addSubviews(grabberView, statusView, tableView, mapButton)
        withBackgroundColor(.Background.elevation1)
        withCornerRadius(Constants.cornerRadius, corners: [.topLeft, .topRight])
        withShadow(opacity: Constants.shadowOpacity)

        setupGrabberView()
        setupStatusView()
        setupTableView()
        setupMapButton()
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

    private func setupStatusView() {
        statusView.snp.makeConstraints {
            $0.top.equalTo(grabberView.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.greaterThanOrEqualToSuperview()
        }
    }

    private func setupTableView() {
        tableView.isScrollEnabled = false
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.keyboardDismissMode = .onDrag
        tableView.contentInset.top = 8

        dataSource.defaultRowAnimation = .fade

        tableView.snp.makeConstraints {
            $0.top.equalTo(grabberView.snp.bottom).offset(10)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }

    private func setupMapButton() {
        mapButton.alpha = 0
        mapButton.configure(with: configurationFactory.createMapButtonConfiguration())
        mapButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            mapButtonBottomConstraint = $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
                .offset(-10)
                .constraint
        }
    }

    private func apply(_ state: HomeState.FlightListState) {
        configureAppearance(with: state.appearance)
        updateVisibility(with: state.contentState)
        renderTableView(from: state.contentState)
        renderStatusViewIfNeeded(from: state.contentState)
    }
}

// MARK: - HomeFlightListConfigurationFactoryDelegate

extension HomeFlightListView: HomeFlightListConfigurationFactoryDelegate {

    func mapButtonDidTap() {
        store.dispatch(event: .ui(.flightList(.onMapButtonTap)))
    }
}

// MARK: - BottomSheetContentViewProtocol

extension HomeFlightListView: BottomSheetContentViewProtocol {

    var scrollView: UIScrollView {
        tableView
    }

    func dispatch(_ event: BottomSheetEvent) {
        switch event {
        case let .onProgressDidChange(progress):
            store.dispatch(event: .ui(.flightList(.onBottomSheetHeightChange(progress: progress))))
        case let .onDetentSet(detent):
            store.dispatch(event: .ui(.flightList(.onDetentSet(detent))))
        }
    }
}

// MARK: - Configuration

extension HomeFlightListView {

    private func configureAppearance(with appearance: HomeState.FlightListState.Appearance) {
        layer.shadowOpacity = appearance.currentShadowOpacity
        withCornerRadius(appearance.currentCornerRadius)
        configureMapButtonAppearance(isHidden: appearance.isMapButtonHidden)
    }

    private func configureMapButtonAppearance(isHidden: Bool) {
        UIView.animate(withDuration: 0.3, delay: 0, options: [.beginFromCurrentState]) {
            if isHidden {
                self.mapButton.alpha = 0
                self.mapButtonBottomConstraint?.update(offset: -1)
            } else {
                self.mapButton.alpha = 1
                self.mapButtonBottomConstraint?.update(offset: -10)
            }

            self.layoutIfNeeded()
        }
    }

    private func updateVisibility(with state: HomeState.FlightListState.ContentState) {
        switch state {
        case .loading, .content:
            tableView.isHidden = false
            statusView.isHidden = true
        case .status:
            tableView.isHidden = true
            statusView.isHidden = false
        }
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

    private func renderStatusViewIfNeeded(from state: HomeState.FlightListState.ContentState) {
        switch state {
        case .loading, .content:
            break
        case let .status(status):
            let configuration = configurationFactory.createStatusViewConfiguration(from: status)
            statusView.configure(with: configuration)
        }
    }
}
