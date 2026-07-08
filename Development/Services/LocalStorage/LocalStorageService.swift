//
//  LocalStorageService.swift
//  flight-demo
//
//  Created by Ivan Puzanov on 01.07.2026.
//

import UIKit

enum LocalStorageServiceFileName: String {
    case airports = "data/airports"
    case flights = "data/flights"
}

protocol LocalStorageServiceProtocol: AnyObject {
    func fetchData<T: Decodable>(
        ofType type: T.Type,
        fileName: LocalStorageServiceFileName,
        completion: (Result<T, Error>) -> Void
    )
}

final class LocalStorageService: LocalStorageServiceProtocol {

    // MARK: - Public

    func fetchData<T: Decodable>(
        ofType type: T.Type,
        fileName: LocalStorageServiceFileName,
        completion: (Result<T, Error>) -> Void
    ) {
        guard let data = NSDataAsset(name: fileName.rawValue)?.data else {
            completion(.failure(NSError()))
            return
        }

        do {
            let jsonDecoder = JSONDecoder()
            let decodedData = try jsonDecoder.decode(T.self, from: data)
            completion(.success(decodedData))
        } catch {
            completion(.failure(error))
        }
    }
}
