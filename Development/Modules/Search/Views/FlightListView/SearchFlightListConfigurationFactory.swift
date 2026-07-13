//
//  SearchFlightListConfigurationFactory.swift
//  flight-demo
//
//  Created by Ivan Puzanov on 30.06.2026.
//

import UIKit

private enum Constants {
    static let shimmerHeight: CGFloat = 169
}

protocol SearchFlightListConfigurationFactoryDelegate: AnyObject {
    func flightDidTap(id: String)
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
            title = Strings.Status.LoadError.title
            subtitle = Strings.Status.LoadError.subtitle
        case .empty:
            image = UIImage(systemName: "tray.fill")
            title = Strings.Status.Empty.title
            subtitle = Strings.Status.Empty.subtitle
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
            labelConfiguration: LabelConfiguration(text: Strings.Map.button, textColor: .white),
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
        let priceBadgeContent = createPriceBadgeContent(from: flight.status)

        return SearchFlightListItemViewConfiguration(
            id: flight.id,
            priceBadgeViewConfiguration: BadgeViewConfiguration(
                imageConfiguration: BadgeViewConfiguration.ImageConfiguration(
                    image: priceBadgeContent.icon, tintColor: .white
                ),
                labelConfiguration: LabelConfiguration(
                    text: formatPriceText(for: flight),
                    textColor: createPriceTextColor(from: flight.status),
                    font: .boldSystemFont(ofSize: 18)
                ),
                insets: .custom(top: 5, bottom: 4, left: 10, right: 10),
                backgroundColor: priceBadgeContent.color
            ),
            airlineImageUrl: URL(string: flight.airline.logo ?? ""),
            baggageBadgeViewConfiguration: createBaggageBageViewConfiguration(
                kilos: flight.baggage.checkedBaggageKg,
                isCarryOn: false
            ),
            carryOnBadgeViewConfiguration: createBaggageBageViewConfiguration(
                kilos: flight.baggage.cabinBaggageKg,
                isCarryOn: true
            ),
            originIataLabelConfiguration: LabelConfiguration(
                text: flight.origin.iata,
                font: .systemFont(ofSize: 22, weight: .bold)
            ),
            originCityLabelConfiguration: LabelConfiguration(text: flight.origin.city),
            destinationIataLabelConfiguration: LabelConfiguration(
                text: flight.destination.iata,
                textAlignment: .right,
                font: .systemFont(ofSize: 22, weight: .bold)
            ),
            destinationCityLabelConfiguration: LabelConfiguration(
                text: flight.destination.city,
                textAlignment: .right
            ),
            onTap: { [weak self] in
                self?.delegate?.flightDidTap(id: flight.id)
            }
        )
    }

    private func formatPriceText(for flight: Flight) -> String {
        flight.price.formatted(.currency(code: flight.currency))
    }

    private func createPriceTextColor(from flightStatus: Flight.Status?) -> UIColor {
        switch flightStatus {
        case .regular, .none:
            return .Text.primary
        case .bestPrice, .fastest, .recommended:
            return .white
        }
    }

    private func createPriceBadgeContent(
        from flightStatus: Flight.Status?
    ) -> (icon: UIImage?, color: UIColor) {
        switch flightStatus {
        case .regular, .none:
            return (icon: nil, color: .secondarySystemFill)
        case .recommended:
            return (icon: UIImage(systemName: "checkmark.seal.fill"), color: .systemBlue)
        case .bestPrice:
            return (icon: UIImage(systemName: "flame.fill"), color: .systemRed)
        case .fastest:
            return (icon: UIImage(systemName: "hare.fill"), color: .systemOrange)
        }
    }

    private func createBaggageBageViewConfiguration(
        kilos: Int,
        isCarryOn: Bool
    ) -> BadgeViewConfiguration? {
        let text: String

        if kilos > 0 {
            text = "\(kilos) Kg"
        } else {
            text = "No baggage"
        }

        return BadgeViewConfiguration(
            imageConfiguration: BadgeViewConfiguration.ImageConfiguration(
                image: isCarryOn
                    ? UIImage(systemName: "handbag.fill")
                    : UIImage(systemName: "suitcase.fill"),
                tintColor: .label
            ),
            labelConfiguration: LabelConfiguration(
                text: text,
                font: .systemFont(ofSize: 14)
            ),
            insets: .custom(top: 4, bottom: 4, left: 10, right: 10),
            backgroundColor: .quaternarySystemFill
        )
    }
}
