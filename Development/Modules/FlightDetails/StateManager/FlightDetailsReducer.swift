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
