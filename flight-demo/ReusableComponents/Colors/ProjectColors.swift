//
//  ProjectColors.swift
//  flight-demo
//
//  Created by Ivan Puzanov on 08.07.2026.
//

import UIKit

extension UIColor {

    enum Text {
        static let primary = UIColor.dynamic(
            dark: .white,
            light: UIColor(red: 33/255, green: 33/255, blue: 33/255, alpha: 1)
        )
    }

    enum Background {
        static let elevation1 = UIColor.dynamic(
            dark: UIColor(red: 16/255, green: 16/255, blue: 16/255, alpha: 1),
            light: .white
        )
        static let elevation2 = UIColor.dynamic(
            dark: UIColor(red: 44/255, green: 44/255, blue: 44/255, alpha: 1),
            light: .white
        )
    }
}

extension UIColor {

    static func dynamic(dark: UIColor, light: UIColor) -> UIColor {
        UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark:
                return dark
            case .light, .unspecified:
                return light
            }
        }
    }
}
