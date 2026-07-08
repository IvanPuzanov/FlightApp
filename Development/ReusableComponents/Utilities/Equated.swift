//
//  Equated.swift
//  flight-demo
//
//  Created by Ivan Puzanov on 05.07.2026.
//

import Foundation

@propertyWrapper
struct Equated<T>: Equatable {
    var wrappedValue: T

    static func == (lhs: Equated<T>, rhs: Equated<T>) -> Bool {
        return true
    }
}
