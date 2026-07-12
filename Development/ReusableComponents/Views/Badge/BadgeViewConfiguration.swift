//
//  BadgeConfiguration.swift
//  flight-demo
//
//  Created by Ivan Puzanov on 01.07.2026.
//

import UIKit

struct BadgeViewConfiguration: Equatable {

    // MARK: - Nested Types

    struct ImageConfiguration: Equatable {
        let image: UIImage?
        let tintColor: UIColor
    }

    // MARK: - Properties

    let imageConfiguration: ImageConfiguration?
    let labelConfiguration: LabelConfiguration
    let insets: Insets
    let backgroundColor: UIColor
}
