//
//  SearchFlightListItemViewConfiguration.swift
//  flight-demo
//
//  Created by Ivan Puzanov on 01.07.2026.
//

import UIKit

struct SearchFlightListItemViewConfiguration: Equatable {
    let id: String
    let priceBadgeViewConfiguration: BadgeViewConfiguration
    let airlineImageUrl: URL?
    let baggageBadgeViewConfiguration: BadgeViewConfiguration?
    let carryOnBadgeViewConfiguration: BadgeViewConfiguration?
    let originIataLabelConfiguration: LabelConfiguration
    let originCityLabelConfiguration: LabelConfiguration
    let destinationIataLabelConfiguration: LabelConfiguration
    let destinationCityLabelConfiguration: LabelConfiguration
    @Equated var onTap: (() -> Void)?
}
