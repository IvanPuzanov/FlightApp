//
//  DataEffectHandler.swift
//  flight-demo
//
//  Created by Ivan Puzanov on 06.07.2026.
//

import Combine
import Foundation

final class DataEffectHandler: EffectHandlerProtocol {

    // MARK: - Dependencies

    private let service: SearchServiceProtocol

    // MARK: - Properties

    private var bag: Set<AnyCancellable> = []

    // MARK: - Initialization

    init(service: SearchServiceProtocol) {
        self.service = service
    }

    // MARK: - Public

    func handle(
        _ effect: SearchEffect,
        completion: @escaping (SearchEvent) -> Void
    ) async {
        switch effect {
        case let .data(dataEffect):
            await handleDataEffect(dataEffect, completion: completion)
        case .navigation:
            break
        }
    }

    // MARK: - Private

    private func handleDataEffect(
        _ effect: SearchEffect.DataEffect,
        completion: @escaping (SearchEvent) -> Void
    ) async {
        switch effect {
        case .loadAirports:
            await processLoadAirports(completion: completion)
        case .loadFlights:
            await processLoadFlights(completion: completion)
        case .getDefaultRegionLocation:
            processGetLocation(completion: completion)
        }
    }

    private func processLoadAirports(completion: @escaping (SearchEvent) -> Void) async {
        let result = await service.loadAirports()

        switch result {
        case let .success(airports):
            completion(.data(.onAirportsLoaded(airports)))
        case let .failure(error):
            completion(.data(.onAirportsFailed))
        }
    }

    private func processLoadFlights(completion: @escaping (SearchEvent) -> Void) async {
        let result = await service.loadFlights()

        switch result {
        case let .success(flights):
            completion(.data(.onFlightsLoaded(flights)))
        case let .failure(error):
            completion(.data(.onFlightsFailed))
        }
    }

    private func processGetLocation(completion: @escaping (SearchEvent) -> Void) {
        service.getDefaultLocation()
            .receive(on: DispatchQueue.main)
            .sink { resultCompletion in
                guard case .failure = resultCompletion else { return }

                completion(.data(.onGetLocationFailed))
            } receiveValue: { coordinate in
                completion(.data(.onGetLocation(coordinate)))
            }.store(in: &bag)
    }
}
