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

    private let service: HomeServiceProtocol

    // MARK: - Properties

    private var bag: Set<AnyCancellable> = []

    // MARK: - Initialization

    init(service: HomeServiceProtocol) {
        self.service = service
    }

    // MARK: - Public

    func handle(
        _ effect: HomeEffect,
        completion: @escaping (HomeEvent) -> Void
    ) {
        switch effect {
        case let .data(dataEffect):
            handleDataEffect(dataEffect, completion: completion)
        case .navigation:
            break
        }
    }

    // MARK: - Private

    private func handleDataEffect(
        _ effect: HomeEffect.DataEffect,
        completion: @escaping (HomeEvent) -> Void
    ) {
        switch effect {
        case .loadAirports:
            processLoadAirports(completion: completion)
        case .loadFlights:
            processLoadFlights(completion: completion)
        case .getDefaultRegionLocation:
            processGetLocation(completion: completion)
        }
    }

    private func processLoadAirports(completion: @escaping (HomeEvent) -> Void) {
        service.loadAirports()
            .receive(on: DispatchQueue.main)
            .sink { resultCompletion in
                guard case .failure = resultCompletion else { return }

                completion(.data(.onAirportsFailed))
            } receiveValue: { airports in
                completion(.data(.onAirportsLoaded(airports)))
            }.store(in: &bag)
    }

    private func processLoadFlights(completion: @escaping (HomeEvent) -> Void) {
        service.loadFlights()
            .receive(on: DispatchQueue.main)
            .sink { resultCompletion in
                guard case .failure = resultCompletion else { return }

                completion(.data(.onFlightsFailed))
            } receiveValue: { flights in
                completion(.data(.onFlightsLoaded(flights)))
            }.store(in: &bag)
    }

    private func processGetLocation(completion: @escaping (HomeEvent) -> Void) {
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
