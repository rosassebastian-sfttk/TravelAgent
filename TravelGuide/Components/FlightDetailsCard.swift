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
    
    private var statusColor: Color {
        switch flight.status.lowercased() {
        case "active": return .green
        case "landed": return .blue
        case "delayed": return .orange
        case "cancelled": return .red
        default: return .gray
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(flight.departure.iata)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundStyle(.primary)
                    
                    Text(flight.flightNumber)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                // Flight path arrow
                HStack(spacing: 8) {
                    Circle()
                        .fill(.secondary)
                        .frame(width: 8, height: 8)
                    
                    Image(systemName: "airplane")
                        .font(.title2)
                        .foregroundStyle(.primary)
                        .rotationEffect(.degrees(90))
                    //todo: modify this with the actual route
                    Rectangle()
                        .fill(.secondary.opacity(0.3))
                        .frame(height: 1)
                        .frame(maxWidth: 30)
                    
                    Circle()
                        .fill(.secondary)
                        .frame(width: 8, height: 8)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text(flight.arrival.iata)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundStyle(.primary)
                    
                    // Status
                    Text(flight.status)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(statusColor.opacity(0.2))
                        .foregroundStyle(statusColor)
                        .clipShape(Capsule())
                }
            }
            
            Divider()
                .opacity(0.3)
            
            // Flight info
            HStack(alignment: .top, spacing: 24) {
                VStack(alignment: .leading, spacing: 8) {
                    FlightInfoSection(
                        title: "Departure",
                        airport: flight.departure.airport,
                        iata: flight.departure.iata,
                        time: flight.departure.scheduledTime,
                        terminal: flight.departure.terminal,
                        gate: flight.departure.gate
                    )
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    FlightInfoSection(
                        title: "Arrival",
                        airport: flight.arrival.airport,
                        iata: flight.arrival.iata,
                        time: flight.arrival.scheduledTime,
                        terminal: flight.arrival.terminal,
                        gate: flight.arrival.gate
                    )
                }
            }
            
            HStack(spacing: 16) {
                Label("Terminal \(flight.departure.terminal ?? "—")", systemImage: "building.2")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                Label("Gate \(flight.departure.gate ?? "—")", systemImage: "door.left.hand.open")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                Spacer()
                
                Text(flight.airline)
                    .font(.caption)
                    .foregroundStyle(.tertiary)
            }
        }
        .padding(20)
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 4)
        .padding(.horizontal, 20)
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

