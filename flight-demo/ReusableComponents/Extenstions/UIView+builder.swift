//
//  UIView+builder.swift
//  flight-demo
//
//  Created by Ivan Puzanov on 28.06.2026.
//

import UIKit

extension UIView {

    enum Corner {
        case topLeft, topRight, bottomLeft, bottomRight

        var toCACornerMask: CACornerMask {
            switch self {
            case .topLeft:
                return .layerMinXMinYCorner
            case .topRight:
                return .layerMaxXMinYCorner
            case .bottomLeft:
                return .layerMinXMaxYCorner
            case .bottomRight:
                return .layerMaxXMaxYCorner
            }
        }
    }

    @discardableResult
    func withBackgroundColor(_ color: UIColor) -> Self {
        backgroundColor = color
        return self
    }

    @discardableResult
    func withCornerRadius(_ radius: CGFloat, corners: [Corner] = []) -> Self {
        layer.cornerRadius = radius
        layer.cornerCurve = .continuous

        var mask: CACornerMask = []
        corners.forEach { mask.insert($0.toCACornerMask) }
        if !mask.isEmpty {
            layer.maskedCorners = mask
        }

        return self
    }

    @discardableResult
    func withShadow(offsetX: CGFloat = 0, offsetY: CGFloat = 0) -> Self {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = 10
        layer.shadowOpacity = 0.1
        layer.shadowOffset = CGSize(width: offsetX, height: offsetY)

        return self
    }
}
