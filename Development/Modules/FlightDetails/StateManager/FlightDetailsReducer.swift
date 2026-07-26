//
//  FlightDetailsReducer.swift
//  FlightDemoApp
//
//  Created by Ivan Puzanov on 09.07.2026.
//

import Foundation

protocol FlightDetailsReducerProtocol: ReducerProtocol {
    func reduce(state: inout FlightDetailsState, event: FlightDetailsEvent) -> [FlightDetailsEffect]
}

final class FlightDetailsReducer: FlightDetailsReducerProtocol {

    // MARK: - Public

    func reduce(
        state: inout FlightDetailsState,
        event: FlightDetailsEvent
    ) -> [FlightDetailsEffect] {
        switch event {
        case let .ui(uiEvent):
            return reduceUiEvent(uiEvent, state: &state)
        }
    }

    // MARK: - Private

    private func reduceUiEvent(
        _ event: FlightDetailsEvent.UIEvent,
        state: inout FlightDetailsState
    ) -> [FlightDetailsEffect] {
        switch event {
        case .onViewDidLoad:
            let flightId = state.flight.id
            state.headerState = FlightDetailsState.HeaderState(
                originIata: state.flight.origin.iata,
                originCity: state.flight.origin.city,
                destinationIata: state.flight.destination.iata,
                destinationCity: state.flight.destination.city
            )
            return [.data(.loadDetails(flightId: flightId))]
        }
    }
}
