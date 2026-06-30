//
//  HomeFlightListView.swift
//  flight-demo
//
//  Created by Ivan Puzanov on 30.06.2026.
//

import UIKit

protocol HomeFlightListModuleInputProtocol: ModuleInputProtocol where State == HomeState.FlightListState {}
protocol HomeFlightListModuleOutputProtocol: ModuleOutputProtocol where Event == HomeEvent.UIEvent {}

final class HomeFlightListView: UIView {

    // MARK: - Dependencies

    weak var bottomSheet: (any BottomSheetProtocol)?
    private let presenter: any HomeFlightListModuleOutputProtocol

    // MARK: - Initialization

    init(presenter: some HomeFlightListModuleOutputProtocol) {
        self.presenter = presenter
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - BottomSheetContentViewProtocol

extension HomeFlightListView: BottomSheetContentViewProtocol {

    func dispatch(_ event: BottomSheetEvent) {
        switch event {
        case .onHeightDidChange:
            break
        }
    }
}

// MARK: - FlightListModuleProtocol

extension HomeFlightListView: HomeFlightListModuleInputProtocol {

    func apply(_ state: HomeState.FlightListState) {
        bottomSheet?.setupDetents(state.bottomSheetDetents)
    }
}
