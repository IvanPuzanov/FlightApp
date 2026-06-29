//
//  ContainerViewConfiguration.swift
//  flight-demo
//
//  Created by Ivan Puzanov on 29.06.2026.
//

import Foundation

struct ContainerViewConfiguration<View: ConfigurableView>: Equatable {
    let viewConfiguration: View.ViewConfiguration
    let insets: Insets
}
