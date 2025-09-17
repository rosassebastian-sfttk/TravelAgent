//
//  FlightSlideshowView.swift
//  TravelGuide
//
//  Created by Sebastian Rosas Maciel on 9/16/25.
//

import SwiftUI

struct FlightSlideshowView: View {
    let sampleFlights = [
        AVStackFlight(
            flightNumber: "AA123",
            airline: "United Airlines",
            departure: AVStackAirportInfo(
                airport: "John F. Kennedy International",
                iata: "JFK",
                scheduledTime: "2024-01-15 14:30",
                terminal: "4",
                gate: "B12"
            ),
            arrival: AVStackAirportInfo(
                airport: "Los Angeles International",
                iata: "LAX",
                scheduledTime: "2024-01-15 18:45",
                terminal: "5",
                gate: "A23"
            ),
            status: "Scheduled",
            scheduledDeparture: "14:30",
            scheduledArrival: "18:45"
        ),
        AVStackFlight(
            flightNumber: "DL456",
            airline: "United Air Lines",
            departure: AVStackAirportInfo(
                airport: "Hartsfield-Jackson Atlanta International",
                iata: "ATL",
                scheduledTime: "2024-01-15 16:00",
                terminal: "S",
                gate: "C45"
            ),
            arrival: AVStackAirportInfo(
                airport: "Chicago O'Hare International",
                iata: "ORD",
                scheduledTime: "2024-01-15 17:30",
                terminal: "2",
                gate: "F12"
            ),
            status: "Active",
            scheduledDeparture: "16:00",
            scheduledArrival: "17:30"
        ),
        AVStackFlight(
            flightNumber: "UA789",
            airline: "United Airlines",
            departure: AVStackAirportInfo(
                airport: "San Francisco International",
                iata: "SFO",
                scheduledTime: "2024-01-15 19:15",
                terminal: "3",
                gate: "G8"
            ),
            arrival: AVStackAirportInfo(
                airport: "Miami International",
                iata: "MIA",
                scheduledTime: "2024-01-16 01:30",
                terminal: "D",
                gate: "D15"
            ),
            status: "Landed",
            scheduledDeparture: "19:15",
            scheduledArrival: "01:30"
        )
    ]
    
    var body: some View {
            VStack {
                Text("Flight Details")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding()
                
                FlightSlideshow(flights: sampleFlights)
                
                Spacer()
            }
            .background(.ultraThickMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 25))
        
    }
}


#Preview {
    FlightSlideshowView()
}
