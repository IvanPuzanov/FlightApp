//
//  ResponseCache.swift
//  flight-demo
//
//  Created by Ivan Puzanov on 05.07.2026.
//

import Foundation

protocol ResponseCacheProtocol {
    func set(_ data: Data, for key: String)
    func get(for key: String) -> Data?
}

final class ResponseCache: ResponseCacheProtocol {

    // MARK: - Dependencies

    static let shared = ResponseCache()
    private let cache = NSCache<NSString, NSData>()

    // MARK: - Initialization

    private init() {}

    // MARK: - Public

    func set(_ data: Data, for key: String) {
        cache.setObject(data as NSData, forKey: key as NSString)
    }

    func get(for key: String) -> Data? {
        cache.object(forKey: key as NSString) as? Data
    }
}
