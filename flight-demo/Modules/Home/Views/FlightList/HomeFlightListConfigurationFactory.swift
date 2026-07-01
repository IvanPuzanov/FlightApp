//
//  HomeFlightListConfigurationFactory.swift
//  flight-demo
//
//  Created by Ivan Puzanov on 30.06.2026.
//

import UIKit

private enum Constants {
    static let shimmerHeight: CGFloat = 160
}

protocol HomeFlightListConfigurationFactoryProtocol: AnyObject {
    func createFlightListCellTypes(from state: HomeState.FlightListState.ContentState) -> [HomeFlightListCellType]
    func createStatusViewConfiguration(
        from status: HomeState.FlightListState.Status
    ) -> StatusViewConfiguration
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
        case .status:
            []
        }
    }

    func createStatusViewConfiguration(
        from status: HomeState.FlightListState.Status
    ) -> StatusViewConfiguration {
        let image: UIImage?
        let title: String
        let subtitle: String

        switch status {
        case .error:
            image = UIImage(systemName: "airplane.departure")
            title = "Load error"
            subtitle = "Error occured during loading"
        case .empty:
            image = UIImage(systemName: "tray.fill")
            title = "No flights"
            subtitle = "There are no flights"
        }

        return StatusViewConfiguration(
            image: image ?? UIImage(),
            imageColor: .systemGray,
            titleLabelConfiguration: LabelConfiguration(
                text: title,
                font: .systemFont(ofSize: 20, weight: .bold)
            ),
            subtitleLabelConfiguration: LabelConfiguration(
                text: subtitle,
                textColor: .secondaryLabel,
                font: .systemFont(ofSize: 16)
            )
        )
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
