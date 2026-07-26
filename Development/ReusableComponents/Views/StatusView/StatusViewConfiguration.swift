//
//  StatusViewConfiguration.swift
//  flight-demo
//
//  Created by Ivan Puzanov on 01.07.2026.
//

import UIKit

struct StatusViewConfiguration: Equatable {

    struct ButtonConfiguration: Equatable {
        let text: String
        @Equated var onTap: () -> Void
    }

    let imageViewConfiguration: ImageViewConfiguration
    let titleLabelConfiguration: LabelConfiguration
    let subtitleLabelConfiguration: LabelConfiguration
    let actionButtonConfiguration: ButtonConfiguration?
}
