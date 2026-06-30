//
//  HomeFlightListConfigurationFactory.swift
//  flight-demo
//
//  Created by Ivan Puzanov on 30.06.2026.
//

import Foundation

private enum Constants {
    static let shimmerHeight: CGFloat = 160
}

protocol HomeFlightListConfigurationFactoryProtocol: AnyObject {
    func createFlightListCellTypes(from state: HomeState.FlightListState.ContentState) -> [HomeFlightListCellType]
}

final class HomeFlightListConfigurationFactory: HomeFlightListConfigurationFactoryProtocol {

    // MARK: - Properties

    private let shimmerUUIDs = [UUID(), UUID(), UUID(), UUID()]

    // MARK: - Public

    func createFlightListCellTypes(
        from state: HomeState.FlightListState.ContentState
    ) -> [HomeFlightListCellType] {
        switch state {
        case .loading:
            createShimmerCellTypes()
        }
    }

    // MARK: - Private

    private func createShimmerCellTypes() -> [HomeFlightListCellType] {
        shimmerUUIDs.map {
            .shimmer(
                TableViewReusableCellConfiguration<ContainerView<ShimmerView>>(
                    viewConfiguration: ContainerViewConfiguration<ShimmerView>(
                        viewConfiguration: ShimmerViewConfiguration(
                            id: $0.uuidString,
                            height: Constants.shimmerHeight
                        ),
                        insets: .custom(top: 6, bottom: 6, left: 16, right: 16)
                    )
                )
            )
        }
    }
}
