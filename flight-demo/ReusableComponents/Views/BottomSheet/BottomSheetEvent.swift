//
//  BottomSheetEvent.swift
//  flight-demo
//
//  Created by Ivan Puzanov on 30.06.2026.
//

import Foundation

enum BottomSheetEvent {
    /// Dispatch on height change. Through value from 0 to 1 (minimum detent to maximum detent)
    case onProgressDidChange(CGFloat)
    case onDetentSet(CGFloat)
}
