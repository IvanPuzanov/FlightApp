//
//  ConfigurableView.swift
//  flight-demo
//
//  Created by Ivan Puzanov on 29.06.2026.
//

import Foundation

protocol ConfigurableView {
    associatedtype ViewConfiguration: Equatable

    func configure(with configuration: ViewConfiguration)
}
