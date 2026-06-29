//
//  SegmentedControlConfiguration.swift
//  flight-demo
//
//  Created by Ivan Puzanov on 29.06.2026.
//

import Foundation

struct SegmentedControlConfiguration: Equatable {
    let segments: [Segment]
}

extension SegmentedControlConfiguration {
    struct Segment: Equatable {
        let text: String
        let isSelected: Bool
    }
}
