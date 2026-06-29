//
//  LabelConfiguration.swift
//  flight-demo
//
//  Created by Ivan Puzanov on 29.06.2026.
//

import UIKit

struct LabelConfiguration: Equatable {
    let text: String
    let textColor: UIColor
    let textAlignment: NSTextAlignment
    let font: UIFont
    let numberOfLines: Int

    init(
        text: String,
        textColor: UIColor = .Text.primary,
        textAlignment: NSTextAlignment = .left,
        font: UIFont = .systemFont(ofSize: 16),
        numberOfLines: Int = 1
    ) {
        self.text = text
        self.textColor = textColor
        self.textAlignment = textAlignment
        self.font = font
        self.numberOfLines = numberOfLines
    }
}
