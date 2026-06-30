//
//  UIColor+interpolate.swift
//  flight-demo
//
//  Created by Ivan Puzanov on 30.06.2026.
//

import UIKit

extension UIColor {
    
    static func interpolate(from: UIColor, to: UIColor, progress: CGFloat) -> UIColor {
        let progress = max(0, min(1, progress))

        var fromR: CGFloat = 0, fromG: CGFloat = 0, fromB: CGFloat = 0, fromA: CGFloat = 0
        var toR: CGFloat = 0, toG: CGFloat = 0, toB: CGFloat = 0, toA: CGFloat = 0

        from.getRed(&fromR, green: &fromG, blue: &fromB, alpha: &fromA)
        to.getRed(&toR, green: &toG, blue: &toB, alpha: &toA)

        let r = fromR + (toR - fromR) * progress
        let g = fromG + (toG - fromG) * progress
        let b = fromB + (toB - fromB) * progress
        let a = fromA + (toA - fromA) * progress

        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
}
