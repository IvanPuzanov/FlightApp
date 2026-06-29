//
//  HomeMapConfigurationFactory.swift
//  flight-demo
//
//  Created by Ivan Puzanov on 29.06.2026.
//

import UIKit

private enum Constants {
    static let flightInfoLeadingIcon = UIImage(systemName: "arrow.left") ?? UIImage()
    static let flightInfoTrailingIcon = UIImage(systemName: "ellipsis") ?? UIImage()

    static let searchLeadingIcon = UIImage(systemName: "magnifyingglass") ?? UIImage()
    static let searchTrailingIcon = UIImage(systemName: "slider.horizontal.3") ?? UIImage()
}

protocol HomeMapConfigurationFactoryProtocol: AnyObject {
    func makeHeaderViewConfiguration(
        from state: HomeState.HeaderState
    ) -> HomeHeaderViewConfiguration
}

protocol HomeBottomSheetConfigurationFactoryProtocol: AnyObject {
    func makeSegmentedControlConfiguration() -> SegmentedControlConfiguration
    func makeFlightDetailsCellType() -> HomeBottomSheetCellType
}

final class HomeConfigurationFactory {}

// MARK: - HomeMapConfigurationFactoryProtocol

extension HomeConfigurationFactory: HomeMapConfigurationFactoryProtocol {

    // MARK: - Public

    func makeHeaderViewConfiguration(
        from state: HomeState.HeaderState
    ) -> HomeHeaderViewConfiguration {
        switch state {
        case let .flightInfo(number, description):
            return HomeHeaderViewConfiguration(
                mode: createHeaderViewFlightInfoMode(number: number, description: description)
            )
        case let .search(text):
            return HomeHeaderViewConfiguration(
                mode: createHeaderViewSearchMode(text: text)
            )
        }
    }

    // MARK: - Private

    private func createHeaderViewFlightInfoMode(
        number: String,
        description: String
    ) -> HomeHeaderViewConfiguration.Mode {
        .flightInfo(
            HomeHeaderViewConfiguration.FlightDetailsModel(
                leadingIcon: Constants.flightInfoLeadingIcon,
                titleLabelText: number,
                subtitleLabelText: description,
                trailingIcon: Constants.flightInfoTrailingIcon
            )
        )
    }

    private func createHeaderViewSearchMode(text: String?) -> HomeHeaderViewConfiguration.Mode {
        .search(
            HomeHeaderViewConfiguration.SearchModel(
                leadingIcon: Constants.searchLeadingIcon,
                text: text,
                placeholderText: "Search flight or aircraft",
                trailingIcon: Constants.searchTrailingIcon
            )
        )
    }
}

// MARK: - HomeBottomSheetConfigurationFactoryProtocol

extension HomeConfigurationFactory: HomeBottomSheetConfigurationFactoryProtocol {

    // MARK: - Public

    func makeSegmentedControlConfiguration() -> SegmentedControlConfiguration {
        SegmentedControlConfiguration(
            segments: [
                SegmentedControlConfiguration.Segment(text: "Trending", isSelected: true),
                SegmentedControlConfiguration.Segment(text: "Near you", isSelected: false)
            ]
        )
    }

    func makeFlightDetailsCellType() -> HomeBottomSheetCellType {
        .flightDetails(
            TableViewReusableCellConfiguration<ContainerView<FlightDetailsView>>(
                viewConfiguration: ContainerViewConfiguration<FlightDetailsView>(
                    viewConfiguration: FlightDetailsViewConfiguration(
                        departureAirportConfiguration: createFlightAirportViewConfiguration(
                            airport: "LED",
                            cityAndCountry: "Saint-Petersburgh, Russia",
                            timeZone: "GMT +3"
                        ),
                        arrivalAirportConfiguration: createFlightAirportViewConfiguration(
                            airport: "IST",
                            cityAndCountry: "Istanbul, Turkey",
                            timeZone: "GMT +3"
                        )
                    ),
                    insets: .eachSide(16)
                )
            )
        )
    }

    // MARK: - Private

    private func createFlightAirportViewConfiguration(
        airport: String,
        cityAndCountry: String,
        timeZone: String
    ) -> FlightAirportViewConfiguration {
        FlightAirportViewConfiguration(
            titleLabelConfiguration: LabelConfiguration(
                text: airport,
                font: .systemFont(ofSize: 24)
            ),
            subtitleLabelConfiguration: LabelConfiguration(
                text: cityAndCountry,
                textAlignment: .center,
                font: .boldSystemFont(ofSize: 16),
                numberOfLines: 2
            ),
            descriptionLabelConfiguration: LabelConfiguration(
                text: timeZone,
                textColor: .secondaryLabel
            ),
            backgroundColor: .secondarySystemBackground
        )
    }
}
