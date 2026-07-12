//
//  Utils.swift
//  FlightDemoApp
//
//  Created by Ivan Puzanov on 11.07.2026.
//

import Foundation

enum Utils {
    static func waitUntil(
        timeout: TimeInterval = 2,
        condition: @escaping () -> Bool
    ) async -> Bool {
        let deadline = Date().addingTimeInterval(timeout)

        while Date() < deadline {
            if condition() {
                return true
            }

            try? await Task.sleep(nanoseconds: 20_000_000)
        }

        return condition()
    }
}
