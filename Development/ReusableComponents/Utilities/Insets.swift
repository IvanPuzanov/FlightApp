//
//  Insets.swift
//  flight-demo
//
//  Created by Ivan Puzanov on 29.06.2026.
//

import Foundation

enum Insets: Equatable {
    case eachSide(CGFloat)
    case custom(top: CGFloat, bottom: CGFloat, left: CGFloat, right: CGFloat)
}
