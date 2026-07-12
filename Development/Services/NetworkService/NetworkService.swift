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

    // MARK: - Public

    func sendRequest<ResponseModel: Decodable>(
        request: APIRequest,
        responseModel: ResponseModel.Type
    ) async -> Result<ResponseModel, Error> {
        guard let urlRequest = request.completeURLRequest() else {
            return .failure(NSError())
        }

        do {
            let decoder = JSONDecoder()
            let (data, _) = try await URLSession.shared.data(for: urlRequest)
            let decodedData = try decoder.decode(ResponseModel.self, from: data)

            return .success(decodedData)
        } catch {
            return .failure(error)
        }
    }
}
