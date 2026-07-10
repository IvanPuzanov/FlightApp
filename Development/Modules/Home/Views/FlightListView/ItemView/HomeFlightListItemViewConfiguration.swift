//
//  HomeFlightListItemViewConfiguration.swift
//  flight-demo
//
//  Created by Ivan Puzanov on 01.07.2026.
//

import UIKit

struct HomeFlightListItemViewConfiguration: Equatable {
    let id: String
    let airlineImageUrl: URL?
    let airlineLabelConfiguration: LabelConfiguration
    let flightNumberLabelConfiguration: LabelConfiguration
    let statusBadgeViewConfiguration: BadgeViewConfiguration
    let originCityLabelConfiguration: LabelConfiguration
    let originIATALabelConfiguration: LabelConfiguration
    let destinationCityLabelConfiguration: LabelConfiguration
    let destinationIATALabelConfiguration: LabelConfiguration
    @Equated var onTap: (() -> Void)?
}
