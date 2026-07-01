//
//  HomeFlightListItemViewConfiguration.swift
//  flight-demo
//
//  Created by Ivan Puzanov on 01.07.2026.
//

import UIKit

struct HomeFlightListItemViewConfiguration: Equatable {
    let id: String
    let airlineImage: UIImage
    let airlineLabelConfiguration: LabelConfiguration
    let flightNumberBadgeConfiguration: BadgeViewConfiguration
    let aircarftBadgeConfiguration: BadgeViewConfiguration
    let originCityLabelConfiguration: LabelConfiguration
    let originIATALabelConfiguration: LabelConfiguration
    let destinationCityLabelConfiguration: LabelConfiguration
    let destinationIATALabelConfiguration: LabelConfiguration
}
