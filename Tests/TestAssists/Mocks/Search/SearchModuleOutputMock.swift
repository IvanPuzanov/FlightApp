//
//  SearchModuleOutputMock.swift
//  FlightDemoApp
//
//  Created by Ivan Puzanov on 10.07.2026.
//

import Foundation
@testable import FlightDemoApp

final class SearchModuleOutputMock: SearchModuleOutput {

    // MARK: - moduleWantsToOpenFlightDetails

    var invokedModuleWantsToOpenFlightDetails = false
    var invokedModuleWantsToOpenFlightDetailsCallsCount = 0
    var invokedModuleWantsToOpenFlightDetailsParameters: (inputData: FlightDetailsInputData, Void)?
    var invokedModuleWantsToOpenFlightDetailsParametersList: [(inputData: FlightDetailsInputData, Void)] = []

    func moduleWantsToOpenFlightDetails(inputData: FlightDetailsInputData) {
        invokedModuleWantsToOpenFlightDetails = true
        invokedModuleWantsToOpenFlightDetailsCallsCount += 1
        invokedModuleWantsToOpenFlightDetailsParameters = (inputData, ())
        invokedModuleWantsToOpenFlightDetailsParametersList.append((inputData, ()))
    }

    // MARK: - moduleWantsToCloseFlightDetails

    var invokedModuleWantsToCloseFlightDetails = false
    var invokedModuleWantsToCloseFlightDetailsCallsCount = 0

    func moduleWantsToCloseFlightDetails() {
        invokedModuleWantsToCloseFlightDetails = true
        invokedModuleWantsToCloseFlightDetailsCallsCount += 1
    }
}
