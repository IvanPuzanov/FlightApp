//
//  UIImageView+ConfigurableView.swift
//  FlightDemoApp
//
//  Created by Ivan Puzanov on 15.07.2026.
//

import UIKit

extension UIImageView: ConfigurableView {

    func configure(with configuration: ImageViewConfiguration) {
        image = configuration.image
        tintColor = configuration.tintColor
        contentMode = configuration.contentMode
    }
}
