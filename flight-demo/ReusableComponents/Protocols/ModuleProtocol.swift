//
//  ModuleProtocol.swift
//  flight-demo
//
//  Created by Ivan Puzanov on 30.06.2026.
//

import Foundation

protocol ModuleInputProtocol: AnyObject {
    associatedtype State

    func apply(_ state: State)
}

protocol ModuleOutputProtocol: AnyObject {
    associatedtype Event

    func dispatch(_ event: Event)
}
