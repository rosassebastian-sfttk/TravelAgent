//
//  AVStackFlight.swift
//  TravelGuide
//
//  Created by Sebastian Rosas Maciel on 9/16/25.
//

import Foundation

struct AVStackFlight: Identifiable {
    let id = UUID()
    let flightNumber: String
    let airline: String
    let departure: AVStackAirportInfo
    let arrival: AVStackAirportInfo
    let status: String
    let scheduledDeparture: String
    let scheduledArrival: String
}

struct AVStackAirportInfo {
    let airport: String
    let iata: String
    let scheduledTime: String
    let terminal: String?
    let gate: String?
}
