//
//  FlightDetailsStore.swift
//  FlightDemoApp
//
//  Created by Ivan Puzanov on 17.07.2026.
//

import Combine

protocol FlightDetailsStoreProtocol: AnyObject {
    var state: FlightDetailsState { get }
    var stateDidChange: ObservableObjectPublisher { get }

    func dispatch(event: FlightDetailsEvent)
}

final class FlightDetailsStore: FlightDetailsStoreProtocol {

    // MARK: - Dependencies

    private let reducer: any FlightDetailsReducerProtocol
    private let dataEffectHandler: FlightDetailsDataEffectHandlerProtocol

    // MARK: - Properties

    var state: FlightDetailsState {
        didSet {
            stateDidChange.send()
        }
    }

    var stateDidChange = ObservableObjectPublisher()

    // MARK: - Initialization

    init(
        state: FlightDetailsState,
        reducer: any FlightDetailsReducerProtocol,
        dataEffectHandler: FlightDetailsDataEffectHandlerProtocol
    ) {
        self.state = state
        self.reducer = reducer
        self.dataEffectHandler = dataEffectHandler
    }

    // MARK: - Public

    func dispatch(event: FlightDetailsEvent) {
        let effects = reducer.reduce(state: &state, event: event)

        effects.forEach { effect in
            switch effect {
            case let .data(dataEffect):
                dataEffectHandler.handle(dataEffect) { event in
                    dispatch(event: event)
                }
            case .navigation:
                break
            }
        }
    }
}
