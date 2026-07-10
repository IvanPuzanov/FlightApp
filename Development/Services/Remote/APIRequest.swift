//
//  APIRequest.swift
//  FlightDemoApp
//
//  Created by Ivan Puzanov on 10.07.2026.
//

import Foundation

struct APIRequest {
    let baseURL: URL
    let path: String

    func completeURLRequest() -> URLRequest? {
        let completeURL = baseURL.appendingPathComponent(path)
        return URLRequest(url: completeURL)
    }
}
