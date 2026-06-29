//
//  HomeBottomSheetViewController.swift
//  flight-demo
//
//  Created by Ivan Puzanov on 28.06.2026.
//

import SnapKit
import UIKit

protocol HomeBottomSheetViewControllerProtocol: AnyObject {
    func apply(state: HomeState.BottomSheetState)
}

final class HomeBottomSheetViewController: UIViewController {

    // MARK: - Typealiases

    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, String>
    typealias DataSource = UITableViewDiffableDataSource<Int, String>

    // MARK: - Dependencies

    private let presenter: HomePresenterProtocol
    private let configurationFactory: HomeBottomSheetConfigurationFactoryProtocol

    // MARK: - UI

    private let grabberView = UIView()
    private let segmentedControl = SegmentedControl()
    private let tableView = UITableView()
    private lazy var panGestureRecognizer = UIPanGestureRecognizer()

    // MARK: - Properties

    private var detents: [HomeState.BottomSheetState.Detent] = []
    private var currentHeight: CGFloat {
        heightConstraint?.layoutConstraints.first?.constant ?? 0
    }
    private var heightConstraint: Constraint?

    private var cellTypes: [String: HomeBottomSheetCellType] = [:]
    private lazy var dataSource = DataSource(tableView: tableView) { tableView, _, identifier in
        guard let cellType = self.cellTypes[identifier] else { return nil }

        switch cellType {
        case let .flightDetails(cellConfiguration):
            let cell = tableView.dequeueReusableCell(with: cellConfiguration)
            return cell
        }
    }

    // MARK: - Initialization

    init(
        presenter: HomePresenterProtocol,
        configurationFactory: HomeBottomSheetConfigurationFactoryProtocol
    ) {
        self.presenter = presenter
        self.configurationFactory = configurationFactory
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
        view.addSubviews(grabberView, segmentedControl, tableView)

        setupAppearance()
        setupGestureRecognizer()
        setupGrabberView()
        setupSegmnetedControl()
        setupTableView()
    }

    private func setupAppearance() {
        view.withBackgroundColor(.systemBackground)
            .withCornerRadius(44, corners: [.topLeft, .topRight])
            .withShadow(offsetY: -10)

        view.snp.makeConstraints {
            heightConstraint = $0.height.equalTo(120).constraint
        }
    }

    private func setupGestureRecognizer() {
        view.addGestureRecognizer(panGestureRecognizer)
        panGestureRecognizer.delegate = self
        panGestureRecognizer.addTarget(self, action: #selector(handlePanGesture))
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

    private func setupSegmnetedControl() {
        let configuration = configurationFactory.makeSegmentedControlConfiguration()
        segmentedControl.configure(with: configuration)

        segmentedControl.snp.makeConstraints {
            $0.top.equalTo(grabberView.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
    }

    private func setupTableView() {
        tableView.separatorStyle = .none

        tableView.snp.makeConstraints {
            $0.top.equalTo(segmentedControl.snp.bottom).offset(10)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }

    @objc
    private func handlePanGesture() {
        switch panGestureRecognizer.state {
        case .began:
            break
        case .changed:
            let translation = panGestureRecognizer.translation(in: view)
            let newHeight = currentHeight - translation.y
            applyHeight(newHeight)
        case .cancelled, .ended:
            clipToNearestDetent()
        default:
            break
        }

        panGestureRecognizer.setTranslation(.zero, in: view)
    }

    private func applyHeight(_ height: CGFloat, animated: Bool = false) {
        UIView.animate(withDuration: animated ? 0.3 : 0) {
            self.heightConstraint?.update(offset: height)
            self.view.superview?.layoutIfNeeded()
        }
    }

    private func clipToNearestDetent() {
        let heights = detents.map { detent in
            switch detent {
            case let .compact(height), let .medium(height), let .custom(height):
                return height
            }
        }

        let nearestHeight = heights.min { abs(currentHeight - $0) < abs(currentHeight - $1) }
        guard let nearestHeight else { return }

        applyHeight(nearestHeight, animated: true)
    }
}

// MARK: - HomeBottomSheetViewController

extension HomeBottomSheetViewController: HomeBottomSheetViewControllerProtocol {

    func apply(state: HomeState.BottomSheetState) {
        configureWithDetents(state.detents)
        renderTableView(with: state)
    }

    private func configureWithDetents(_ detents: [HomeState.BottomSheetState.Detent]) {
        self.detents = detents
        for case let .compact(height) in detents {
            applyHeight(height)
        }
    }

    private func renderTableView(with state: HomeState.BottomSheetState) {
        let newCellTypes = [
            configurationFactory.makeFlightDetailsCellType()
        ]

        let dictionary = Dictionary(
            uniqueKeysWithValues: zip(
                newCellTypes.map { $0.id },
                newCellTypes
            )
        )
        cellTypes = dictionary

        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(newCellTypes.map { $0.id }, toSection: 0)
        dataSource.apply(snapshot)
    }
}

// MARK: - UIGestureRecognizerDelegate

extension HomeBottomSheetViewController: UIGestureRecognizerDelegate {
    // TODO: - Add pan gesutre handling
}
