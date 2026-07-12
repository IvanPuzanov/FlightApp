//
//  APIConfiguration.swift
//  FlightDemoApp
//
//  Created by Ivan Puzanov on 12.07.2026.
//

import Foundation

struct APIConfiguration {
    let baseURL: URL

    static let production = APIConfiguration(
        baseURL: URL(string: "https://raw.githubusercontent.com/IvanPuzanov/FlightAppMockAPI/main")!
    )
}
