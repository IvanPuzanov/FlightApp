//
//  ReducerProtocol.swift
//  FlightDemoApp
//
//  Created by Ivan Puzanov on 09.07.2026.
//

import Foundation

protocol ReducerProtocol: AnyObject {
    associatedtype Event
    associatedtype State
    associatedtype Effect

    func reduce(state: inout State, event: Event) -> [Effect]
}
