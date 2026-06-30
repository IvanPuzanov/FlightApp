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

    // MARK: - Dependencies

    weak var bottomSheet: (any BottomSheetProtocol)?
    private let presenter: any HomeFlightListModuleOutputProtocol

    // MARK: - UI

    private let grabberView = UIView()

    // MARK: - Initialization

    init(presenter: some HomeFlightListModuleOutputProtocol) {
        self.presenter = presenter
        super.init(frame: .zero)

        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private

    private func setupUI() {
        addSubview(grabberView)
        withBackgroundColor(.Background.elevation1)
        withCornerRadius(44)
        withShadow()

        setupGrabberView()
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
        bottomSheet?.setupDetents(state.bottomSheetDetents)
        grabberView.isHidden = state.isGrabberHidden
        layer.shadowOpacity = state.isGrabberHidden ? 0 : 0.1
    }
}
