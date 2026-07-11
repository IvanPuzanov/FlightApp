//
//  NetworkService.swift
//  FlightDemoApp
//
//  Created by Ivan Puzanov on 10.07.2026.
//

import Foundation

protocol NetworkServiceProtocol: AnyObject {
    func sendRequest<ResponseModel: Decodable>(
        request: APIRequest,
        responseModel: ResponseModel.Type
    ) async throws -> Result<ResponseModel, Error>
}

final class NetworkService: NetworkServiceProtocol {

    // MARK: - Dependencies

    private let cacher: ResponseCacheProtocol = ResponseCache.shared

    // MARK: - Public

    func sendRequest<ResponseModel: Decodable>(
        request: APIRequest,
        responseModel: ResponseModel.Type
    ) async throws -> Result<ResponseModel, Error> {
        guard let urlRequest = request.completeURLRequest() else { throw NSError() }

        let decoder = JSONDecoder()
        let data: Data

        if let dataFromCache = getDataFromCache(urlRequest: urlRequest) {
            data = dataFromCache
        } else {
            data = try await URLSession.shared.data(for: urlRequest).0
        }

        let decodedData = try decoder.decode(ResponseModel.self, from: data)

        return .success(decodedData)
    }

    // MARK: - Private

    private func getDataFromCache(urlRequest: URLRequest) -> Data? {
        guard let urlString = urlRequest.url?.absoluteString else { return nil }

        return cacher.get(for: urlString)
    }
}
