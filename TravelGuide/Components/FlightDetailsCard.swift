//
//  FlightDetailsCard.swift
//  TravelGuide
//
//  Created by Sebastian Rosas Maciel on 9/16/25.
//

import SwiftUI

struct FlightDetailsCard: View {
    let flight: AVStackFlight
    @State private var offset = CGSize.zero
    var removal: (() -> Void)? = nil
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                Text(flight.flightNumber)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Text(flight.airline)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            // Información de salida
            FlightInfoSection(
                title: "Liftoff",
                airport: flight.departure.airport,
                iata: flight.departure.iata,
                time: flight.departure.scheduledTime,
                terminal: flight.departure.terminal,
                gate: flight.departure.gate
            )
            
            // Información de llegada
            FlightInfoSection(
                title: "Arrival",
                airport: flight.arrival.airport,
                iata: flight.arrival.iata,
                time: flight.arrival.scheduledTime,
                terminal: flight.arrival.terminal,
                gate: flight.arrival.gate
            )
            
            // Estado del vuelo
            HStack {
                StatusBadge(status: flight.status)
                Spacer()
                Text("Programmed: \(flight.scheduledDeparture) - \(flight.scheduledArrival)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        .padding(.horizontal)
        .offset(x: offset.width, y: 0)
        .rotationEffect(.degrees(Double(offset.width / 40)))
        .opacity(2 - Double(abs(offset.width / 50)))
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    offset = gesture.translation
                }
                .onEnded { _ in
                    if abs(offset.width) > 100 {
                        removal?()
                    } else {
                        withAnimation {
                            offset = .zero
                        }
                    }
                }
        )
    }
}

#Preview("Flight Card") {
    FlightDetailsCard(flight: AVStackFlight(
        flightNumber: "AA123",
        airline: "American Airlines",
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
    ))
}

