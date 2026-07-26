//
//  SearchFlightListConfigurationFactory.swift
//  flight-demo
//
//  Created by Ivan Puzanov on 30.06.2026.
//

import UIKit

private enum Constants {
    static let shimmerHeight: CGFloat = 169

    static let emptyStatusImage = UIImage(systemName: "tray.fill")
    static let errorStatusImage = UIImage(systemName: "airplane.departure")
    static let mapButtonImage = UIImage(systemName: "map.fill")

    static let recommendedPriceBadgeImage = UIImage(systemName: "checkmark.seal.fill")
    static let fastestPriceBadgeImage = UIImage(systemName: "hare.fill")
    static let bestPriceBadgeImage = UIImage(systemName: "flame.fill")

    static let carryOnImage = UIImage(systemName: "handbag.fill")
    static let baggageImage = UIImage(systemName: "suitcase.fill")
}

protocol SearchFlightListConfigurationFactoryDelegate: AnyObject {
    func flightDidTap(id: String, from: String, to: String)
    func retryButtonDidTap()
    func mapButtonDidTap()
}

protocol SearchFlightListConfigurationFactoryProtocol: AnyObject {
    func createFlightListCellTypes(
        from state: SearchState.FlightListState.ContentState
    ) -> [SearchFlightListCellType]

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
            image = Constants.errorStatusImage
            title = Strings.Status.LoadError.title
            subtitle = Strings.Status.LoadError.subtitle
        case .empty:
            image = Constants.emptyStatusImage
            title = Strings.Status.Empty.title
            subtitle = Strings.Status.Empty.subtitle
        }

        return StatusViewConfiguration(
            imageViewConfiguration: ImageViewConfiguration(
                image: image ?? UIImage(),
                tintColor: .systemGray,
                contentMode: .scaleAspectFit
            ),
            titleLabelConfiguration: LabelConfiguration(
                text: title,
                textAlignment: .center,
                font: .systemFont(ofSize: 20, weight: .bold)
            ),
            subtitleLabelConfiguration: LabelConfiguration(
                text: subtitle,
                textColor: .secondaryLabel,
                textAlignment: .center,
                font: .systemFont(ofSize: 16)
            ),
            actionButtonConfiguration: createRetryButtonConfigurationIfNeeded(for: status)
        )
    }

    func createMapButtonConfiguration() -> SearchFlightListMapButtonConfiguration {
        SearchFlightListMapButtonConfiguration(
            image: Constants.mapButtonImage,
            imageTintColor: .white,
            labelConfiguration: LabelConfiguration(
                text: Strings.Map.button,
                textColor: .white
            ),
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

    private func createRetryButtonConfigurationIfNeeded(
        for status: SearchState.FlightListState.Status
    ) -> StatusViewConfiguration.ButtonConfiguration? {
        switch status {
        case .error:
            return StatusViewConfiguration.ButtonConfiguration(
                text: Strings.retry,
                onTap: { [weak self] in
                    self?.delegate?.retryButtonDidTap()
                }
            )
        case .empty:
            return nil
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
            id: flight.id,
            priceBadgeViewConfiguration: createPriceBadgeViewConfiguration(
                status: flight.status,
                price: formatPriceText(price: flight.price, currency: flight.currency)
            ),
            airlineImageUrl: URL(string: flight.airline.logo ?? ""),
            baggageBadgeViewConfiguration: createBaggageBageViewConfiguration(
                weight: flight.baggage.checkedBaggageKg,
                isCarryOn: false
            ),
            carryOnBadgeViewConfiguration: createBaggageBageViewConfiguration(
                weight: flight.baggage.cabinBaggageKg,
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
                self?.delegate?.flightDidTap(
                    id: flight.id,
                    from: flight.origin.iata,
                    to: flight.destination.iata
                )
            }
        )
    }

    private func formatPriceText(price: Decimal, currency: String) -> String {
        price.formatted(.currency(code: currency))
    }

    private func createPriceBadgeViewConfiguration(
        status: Flight.Status?,
        price: String
    ) -> BadgeViewConfiguration {
        let backgroundColor = createPriceBadgeBackgroundColor(from: status)

        return BadgeViewConfiguration(
            imageViewConfiguration: createPriceBadgeImageViewConfiguration(from: status),
            labelConfiguration: LabelConfiguration(
                text: price,
                textColor: createPriceTextColor(from: status),
                font: .boldSystemFont(ofSize: 16)
            ),
            insets: .custom(top: 5, bottom: 4, left: 10, right: 10),
            backgroundColor: backgroundColor
        )
    }

    private func createPriceBadgeImageViewConfiguration(
        from status: Flight.Status?
    ) -> ImageViewConfiguration? {
        let image: UIImage?

        switch status {
        case .regular, .none:
            return nil
        case .recommended:
            image = Constants.recommendedPriceBadgeImage
        case .bestPrice:
            image = Constants.bestPriceBadgeImage
        case .fastest:
            image = Constants.fastestPriceBadgeImage
        }

        return ImageViewConfiguration(
            image: image,
            tintColor: .white,
            contentMode: .scaleAspectFit
        )
    }

    private func createPriceTextColor(from flightStatus: Flight.Status?) -> UIColor {
        switch flightStatus {
        case .regular, .none:
            return .Text.primary
        case .bestPrice, .fastest, .recommended:
            return .white
        }
    }

    private func createPriceBadgeBackgroundColor(
        from status: Flight.Status?
    ) -> UIColor {
        switch status {
        case .regular, .none:
            return .secondarySystemFill
        case .recommended:
            return .systemBlue
        case .bestPrice:
            return .systemRed
        case .fastest:
            return .systemOrange
        }
    }

    private func createBaggageBageViewConfiguration(
        weight: Int,
        isCarryOn: Bool
    ) -> BadgeViewConfiguration? {
        let text = weight == .zero
            ? Strings.Baggage.nobaggage
            : Strings.Baggage.weight(weight)

        return BadgeViewConfiguration(
            imageViewConfiguration: ImageViewConfiguration(
                image: isCarryOn ? Constants.carryOnImage : Constants.baggageImage,
                tintColor: .Text.primary,
                contentMode: .scaleAspectFill
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
