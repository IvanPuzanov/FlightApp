//
//  SearchFlightListConfigurationFactory.swift
//  flight-demo
//
//  Created by Ivan Puzanov on 30.06.2026.
//

import UIKit

private enum Constants {
    static let shimmerHeight: CGFloat = 160
}

protocol SearchFlightListConfigurationFactoryDelegate: AnyObject {
    func flightDidTap(id: Int)
    func mapButtonDidTap()
}

protocol SearchFlightListConfigurationFactoryProtocol: AnyObject {
    func createFlightListCellTypes(from state: SearchState.FlightListState.ContentState) -> [SearchFlightListCellType]
    func createStatusViewConfiguration(
        from status: SearchState.FlightListState.Status
    ) -> StatusViewConfiguration
    func createMapButtonConfiguration() -> SearchFlightListMapButtonConfiguration
}

final class SearchFlightListConfigurationFactory: SearchFlightListConfigurationFactoryProtocol {

    // MARK: - Properties

    weak var delegate: SearchFlightListConfigurationFactoryDelegate?
    private let shimmerUUIDs = [UUID(), UUID(), UUID(), UUID()]

    // MARK: - Public

    func createFlightListCellTypes(
        from state: SearchState.FlightListState.ContentState
    ) -> [SearchFlightListCellType] {
        switch state {
        case .loading:
            return createShimmerCellTypes()
        case .status:
            return []
        case let .content(flights):
            return createFlightItemCellTypes(from: flights)
        }
    }

    func createStatusViewConfiguration(
        from status: SearchState.FlightListState.Status
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

    func createMapButtonConfiguration() -> SearchFlightListMapButtonConfiguration {
        SearchFlightListMapButtonConfiguration(
            image: UIImage(systemName: "map.fill"),
            imageTintColor: .white,
            labelConfiguration: LabelConfiguration(text: "Map", textColor: .white),
            backgroundColor: .black,
            onTap: { [weak self] in
                self?.delegate?.mapButtonDidTap()
            }
        )
    }

    // MARK: - Private

    private func createShimmerCellTypes() -> [SearchFlightListCellType] {
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

    private func createFlightItemCellTypes(from flights: [Flight]) -> [SearchFlightListCellType] {
        flights.map {
            .flight(
                TableViewReusableCellConfiguration<ContainerView<SearchFlightListItemView>>(
                    viewConfiguration: ContainerViewConfiguration<SearchFlightListItemView>(
                        viewConfiguration: createSearchFlightListItemViewConfiguration(from: $0),
                        insets: .custom(top: 8, bottom: 8, left: 16, right: 16)
                    )
                )
            )
        }
    }

    private func createSearchFlightListItemViewConfiguration(
        from flight: Flight
    ) -> SearchFlightListItemViewConfiguration {
        SearchFlightListItemViewConfiguration(
            id: flight.flightNumber,
            airlineImageUrl: URL(
                string: "https://images.kiwi.com/airlines/128/\(flight.airlineCode).png"
            ),
            airlineLabelConfiguration: LabelConfiguration(
                text: flight.airline,
                font: .systemFont(ofSize: 16, weight: .bold)
            ),
            flightNumberLabelConfiguration: LabelConfiguration(
                text: flight.flightNumber,
                font: .systemFont(ofSize: 14)
            ),
            statusBadgeViewConfiguration: BadgeViewConfiguration(
                image: UIImage(systemName: "circle.fill"),
                imageTintColor: createColor(from: flight.status),
                labelConfiguration: createStatusLabelConfiguration(from: flight.status),
                backgroundColor: createColor(from: flight.status).withAlphaComponent(0.1)
            ),
            originCityLabelConfiguration: LabelConfiguration(text: flight.originCity),
            originIATALabelConfiguration: LabelConfiguration(
                text: flight.originIata,
                font: .systemFont(ofSize: 22, weight: .bold)
            ),
            destinationCityLabelConfiguration: LabelConfiguration(text: flight.destinationCity),
            destinationIATALabelConfiguration: LabelConfiguration(
                text: flight.destinationIata,
                font: .systemFont(ofSize: 22, weight: .bold)
            ),
            onTap: { [weak self] in
                self?.delegate?.flightDidTap(id: flight.id)
            }
        )
    }

    private func createStatusLabelConfiguration(from status: Flight.FlightStatus) -> LabelConfiguration {
        let text: String

        switch status {
        case .boarding:
            text = "Boarding"
        case .inAir:
            text = "In Air"
        case .delayed:
            text = "Delayed"
        case .landed:
            text = "Landed"
        case .cancelled:
            text = "Cancelled"
        }

        return LabelConfiguration(text: text, font: .systemFont(ofSize: 14))
    }

    private func createColor(from flightStatus: Flight.FlightStatus) -> UIColor {
        switch flightStatus {
        case .boarding:
            return .systemBlue
        case .inAir:
            return .systemGreen
        case .delayed:
            return .systemOrange
        case .landed:
            return .secondarySystemFill
        case .cancelled:
            return .systemRed
        }
    }
}
