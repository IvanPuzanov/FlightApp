//
//  HomeReducerTests.swift
//  flight-demoTests
//
//  Created by Ivan Puzanov on 08.07.2026.
//

import XCTest
@testable import FlightDemoApp

final class HomeReducerTests: XCTestCase {

    func test_onViewDidLoad_dispatchesLoadDataEffects() {
        let reducer = HomeReducer()
        var state = HomeState.initial

        let effects = reducer.reduce(
            state: &state,
            event: .ui(.common(.onViewDidLoad))
        )

        XCTAssertEqual(effects, [.data(.loadFlights), .data(.loadAirports)])
    }
}
