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
    ) async -> Result<ResponseModel, Error>
}

final class NetworkService: NetworkServiceProtocol {

    // MARK: - Properties

    private let urlSession: URLSession

    // MARK: - Initialization

    init(urlSession: URLSession) {
        self.urlSession = urlSession
    }

    // MARK: - Public

    func sendRequest<ResponseModel: Decodable>(
        request: APIRequest,
        responseModel: ResponseModel.Type
    ) async -> Result<ResponseModel, Error> {
        guard let urlRequest = request.urlRequest() else {
            return .failure(NSError())
        }

        do {
            let decoder = JSONDecoder()
            let (data, _) = try await urlSession.data(for: urlRequest)
            let decodedData = try decoder.decode(ResponseModel.self, from: data)

            return .success(decodedData)
        } catch {
            return .failure(error)
        }
    }
}
