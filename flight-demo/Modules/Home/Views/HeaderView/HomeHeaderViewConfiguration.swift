//
//  HomeHeaderViewConfiguration.swift
//  flight-demo
//
//  Created by Ivan Puzanov on 29.06.2026.
//

import UIKit

struct HomeHeaderViewConfiguration: Equatable {
    let mode: Mode
}

extension HomeHeaderViewConfiguration {
    enum Mode: Equatable {
        case flightInfo(FlightDetailsModel)
        case search(SearchModel)
    }

    struct FlightDetailsModel: Equatable {
        let leadingIcon: UIImage
        let titleLabelText: String
        let subtitleLabelText: String
        let trailingIcon: UIImage
        @Equated var onTrailingIconTap: (() -> Void)?
    }

    struct SearchModel: Equatable {
        let leadingIcon: UIImage
        let text: String?
        let placeholderText: String
        let trailingIcon: UIImage
        @Equated var onTrailingIconTap: (() -> Void)?
    }
}
