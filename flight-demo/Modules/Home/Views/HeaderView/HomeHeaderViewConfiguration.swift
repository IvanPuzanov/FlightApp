//
//  HomeHeaderViewConfiguration.swift
//  flight-demo
//
//  Created by Ivan Puzanov on 29.06.2026.
//

import UIKit

struct HomeHeaderViewConfiguration {
    let mode: Mode
}

extension HomeHeaderViewConfiguration {
    enum Mode {
        case flightDetails(FlightDetailsModel)
        case search(SearchModel)
    }

    struct FlightDetailsModel {
        let leadingIcon: UIImage
        let titleLabelText: String
        let subtitleLabelText: String
        let trailingIcon: UIImage
    }

    struct SearchModel {
        let leadingIcon: UIImage
        let placeholderText: String
        let trailingIcon: UIImage
    }
}
