//
//  UIStackView+addArrangedSubviews.swift
//  flight-demo
//
//  Created by Ivan Puzanov on 29.06.2026.
//

import UIKit

extension UIStackView {

    func addArrangedSubviews(_ views: UIView...) {
        views.forEach {
            addArrangedSubview($0)
        }
    }
}
