//
//  SearchFlightListMapButtonConfiguration.swift
//  flight-demo
//
//  Created by Ivan Puzanov on 05.07.2026.
//

import UIKit

struct SearchFlightListMapButtonConfiguration: Equatable {
    let image: UIImage?
    let imageTintColor: UIColor
    let labelConfiguration: LabelConfiguration
    let backgroundColor: UIColor
    @Equated var onTap: (() -> Void)?
}
