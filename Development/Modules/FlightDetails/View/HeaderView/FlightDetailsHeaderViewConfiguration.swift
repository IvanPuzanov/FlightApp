//
//  FlightDetailsHeaderViewConfiguration.swift
//  FlightDemoApp
//
//  Created by Ivan Puzanov on 17.07.2026.
//

import Foundation

struct FlightDetailsHeaderViewConfiguration: Equatable {
    let originLabelConfiguration: LabelConfiguration
    let originIataLabelConfiguration: LabelConfiguration
    let originCityLabelConfiguration: LabelConfiguration
    let destinationLabelConfiguration: LabelConfiguration
    let destinationIataLabelConfiguration: LabelConfiguration
    let destinationCityLabelConfiguration: LabelConfiguration
    let timeLabelConfiguration: LabelConfiguration
}
