//
//  FlightDetailsViewController.swift
//  FlightDemoApp
//
//  Created by Ivan Puzanov on 09.07.2026.
//

import Combine
import SnapKit
import UIKit

final class FlightDetailsViewController: UIViewController {

    // MARK: - Dependencies

    private let store: FlightDetailsStoreProtocol
    private let configurationFactory: FlightDetailsConfigurationFactoryProtocol

    // MARK: - UI

    private let headerView = ContainerView<FlightDetailsHeaderView>()

    // MARK: - Properties

    private var bag: Set<AnyCancellable> = []

    // MARK: - Initialization

    init(
        store: FlightDetailsStoreProtocol,
        configurationFactory: FlightDetailsConfigurationFactoryProtocol
    ) {
        self.store = store
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
        setupBindings()

        store.dispatch(event: .ui(.onViewDidLoad))
    }

    // MARK: - Public

    private func setupUI() {
        view.addSubview(headerView)
        view.backgroundColor = .systemBackground

        setupAsBottomSheet()
        setupHeaderView()
    }

    private func setupBindings() {
        store.stateDidChange
            .compactMap { [weak self] in
                self?.store.state
            }
            .removeDuplicates()
            .sink(receiveValue: { [weak self] state in
                self?.apply(state)
            })
            .store(in: &bag)
    }

    private func setupAsBottomSheet() {
        isModalInPresentation = true
        
        if let sheet = sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.largestUndimmedDetentIdentifier = .large
        }
    }

    private func setupHeaderView() {
        headerView.snp.makeConstraints {
            $0.leading.top.trailing.equalToSuperview()
        }
    }

    private func apply(_ state: FlightDetailsState) {
        let configuration = configurationFactory.createHeaderViewConfiguration(from: state)
        headerView.configure(with: configuration)
    }
}
