//
//  HomeService.swift
//  flight-demo
//
//  Created by Ivan Puzanov on 28.06.2026.
//

import Foundation

protocol HomeServiceProtocol: AnyObject {
    func loadData()
}

final class HomeService: HomeServiceProtocol {

    // MARK: - Public

    func loadData() {}
}
