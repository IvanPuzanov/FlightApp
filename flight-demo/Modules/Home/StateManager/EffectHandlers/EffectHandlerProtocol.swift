//
//  EffectHandlerProtocol.swift
//  flight-demo
//
//  Created by Ivan Puzanov on 06.07.2026.
//

import Foundation

protocol EffectHandlerProtocol: AnyObject {
    func handle(_ effect: HomeEffect, completion: @escaping (HomeEvent) -> Void)
}
