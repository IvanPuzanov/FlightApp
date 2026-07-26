//
//  FlightDetailsConfigurationFactory.swift
//  FlightDemoApp
//
//  Created by Ivan Puzanov on 17.07.2026.
//

import UIKit

protocol FlightDetailsConfigurationFactoryProtocol: AnyObject {
    func createHeaderViewConfiguration(
        from state: FlightDetailsState
    ) -> ContainerViewConfiguration<FlightDetailsHeaderView>
}

final class FlightDetailsConfigurationFactory: FlightDetailsConfigurationFactoryProtocol {

    // MARK: - Public

    func createHeaderViewConfiguration(
        from state: FlightDetailsState
    ) -> ContainerViewConfiguration<FlightDetailsHeaderView> {
        ContainerViewConfiguration<FlightDetailsHeaderView>(
            viewConfiguration: FlightDetailsHeaderViewConfiguration(
                originLabelConfiguration: LabelConfiguration(
                    text: "From",
                    textColor: .secondaryLabel,
                    font: .boldSystemFont(ofSize: 16)
                ),
                originIataLabelConfiguration: LabelConfiguration(
                    text: state.flight.origin.iata,
                    textColor: .Text.primary,
                    font: .boldSystemFont(ofSize: 28)
                ),
                originCityLabelConfiguration: LabelConfiguration(
                    text: state.flight.origin.city,
                    textColor: .Text.primary,
                    font: .systemFont(ofSize: 16)
                ),
                destinationLabelConfiguration: LabelConfiguration(
                    text: "To",
                    textColor: .secondaryLabel,
                    textAlignment: .right,
                    font: .boldSystemFont(ofSize: 16)
                ),
                destinationIataLabelConfiguration: LabelConfiguration(
                    text: state.flight.destination.iata,
                    textColor: .Text.primary,
                    textAlignment: .right,
                    font: .boldSystemFont(ofSize: 28)
                ),
                destinationCityLabelConfiguration: LabelConfiguration(
                    text: state.flight.destination.city,
                    textColor: .Text.primary,
                    textAlignment: .right,
                    font: .systemFont(ofSize: 16)
                ),
                timeLabelConfiguration: LabelConfiguration(
                    text: "1 day and 12 hours",
                    textColor: .systemBlue
                )
            ),
            insets: .custom(top: 20, bottom: 0, left: 20, right: 20)
        )
    }
}
