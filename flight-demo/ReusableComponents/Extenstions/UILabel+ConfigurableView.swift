//
//  UILabel+ConfigurableView.swift
//  flight-demo
//
//  Created by Ivan Puzanov on 29.06.2026.
//

import UIKit

extension UILabel: ConfigurableView {

    func configure(with configuration: LabelConfiguration) {
        text = configuration.text
        textColor = configuration.textColor
        textAlignment = configuration.textAlignment
        font = configuration.font
        numberOfLines = configuration.numberOfLines
    }
}
