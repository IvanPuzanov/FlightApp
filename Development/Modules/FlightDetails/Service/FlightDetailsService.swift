//
//  FlightDetailsService.swift
//  FlightDemoApp
//
//  Created by Ivan Puzanov on 18.07.2026.
//

import Foundation

protocol FlightDetailsServiceProtocol: AnyObject {
    func loadFlightDetails(id: String) -> Result<FlightDetails, Error>
}
