//
//  SwiftUIView.swift
//  TravelGuide
//
//  Created by Sebastian Rosas Maciel on 9/15/25.


import SwiftUI
import WidgetKit
import MapKit

extension String {
    func toDate() -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return formatter.date(from: self)
    }
}

struct FlightDetailsMediumWidgetView: View {
    var flight: Flight
    @Environment(\.widgetRenderingMode) var widgetRenderingMode
    
    var status: FlightStatus {
        if flight.live?.isGround == true {
            return .landed
        } else if flight.live?.latitude != nil {
            return .active
        } else {
            return .scheduled
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Encabezado
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(flight.arrival?.iata ?? "DFW")
                        .foregroundStyle(.primary)
                        .font(.title2)
                        .fontWeight(.bold)
                        .widgetAccentable()
                    
                    Text("UA123")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .widgetAccentable(false) 
                }
                
                Spacer()
                
                Image("UALogo")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 50)
//
                
                Spacer()
                
                Text(status.rawValue)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        widgetRenderingMode == .fullColor ?
                        Color.green.opacity(0.2) :
                        Color.clear
                    )
                    .clipShape(Capsule())
                    .widgetAccentable()
            }
            
            Divider()
                .widgetAccentable(false)
            
            // Detalle en dos columnas
            HStack(alignment: .top, spacing: 24) {
                VStack(alignment: .leading, spacing: 6) {
                    Label("Gate \(flight.departure?.gate ?? "—")", systemImage: "door.left.hand.open")
                        .font(.caption)
                        .foregroundStyle(.primary)
                        .widgetAccentable(false)
                }
                
                if let scheduledTime = flight.departure?.scheduled?.toDate() {
                    Label("\(scheduledTime.addingTimeInterval(-30 * 60), style: .time)", systemImage: "clock")
                        .font(.caption)
                        .foregroundStyle(.primary)
                        .widgetAccentable(false)
                }
                Label(flight.aircraft?.iata ?? "B738", systemImage: "airplane")
                    .font(.caption)
                    .foregroundStyle(.primary)
                    .padding(.leading)
                    .widgetAccentable(false)
            }
        }
        .padding()
        // Conditional background based on rendering mode
        .if(widgetRenderingMode == .fullColor) { view in
            view.containerBackground(for: .widget) {
                Color(.systemBackground)
            }
        }
    }
}

// Estructuras para la API de Aviationstack
struct FlightData: Codable {
    let data: [Flight]?
}

struct Flight: Codable {
    let flight: FlightInfo?
    let departure: AirportInfo?
    let arrival: AirportInfo?
    let aircraft: AircraftInfo?
    let live: LiveData?
}

struct FlightInfo: Codable {
    let iata: String?
    let icao: String?
    let number: String?
}

struct AirportInfo: Codable {
    let airport: String?
    let iata: String?
    let icao: String?
    let scheduled: String?
    let estimated: String?
    let actual: String?
    let delay: Int?
    let terminal: String?
    let gate: String?
}

struct AircraftInfo: Codable {
    let registration: String?
    let iata: String?
    let icao: String?
    let icao24: String?
}

struct LiveData: Codable {
    let updated: String?
    let latitude: Double?
    let longitude: Double?
    let altitude: Double?
    let direction: Double?
    let speedHorizontal: Double?
    let speedVertical: Double?
    let isGround: Bool?
}


enum FlightStatus: String {
    case scheduled = "Scheduled"
    case active = "Active"
    case landed = "Landing"
    case cancelled = "Cancelled"
    case incident = "Incident"
    case diverted = "Diverted"
    
    var color: Color {
        switch self {
        case .scheduled: return .blue
        case .active: return .green
        case .landed: return .orange
        case .cancelled: return .red
        case .incident: return .purple
        case .diverted: return .yellow
        }
    }
}

struct AirportAnnotation: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
    let terminal: String?
    let gate: String?
    
    init(coordinate: CLLocationCoordinate2D, terminal: String? = nil, gate: String? = nil) {
        self.coordinate = coordinate
        self.terminal = terminal
        self.gate = gate
    }
}


struct MockData {
    static let flight = Flight(
        flight: FlightInfo(iata: "AA123", icao: "AAL123", number: "123"),
        departure: AirportInfo(
            airport: "Dallas/Fort Worth International Airport",
            iata: "DFW",
            icao: "KDFW",
            scheduled: "2024-01-15T14:30:00+0000",
            estimated: "2024-01-15T14:45:00+0000",
            actual: nil,
            delay: 15,
            terminal: "D",
            gate: "D12"
        ),
        arrival: AirportInfo(
            airport: "Los Angeles International Airport",
            iata: "LAX",
            icao: "KLAX",
            scheduled: "2024-01-15T16:45:00+0000",
            estimated: "2024-01-15T17:00:00+0000",
            actual: nil,
            delay: 15,
            terminal: "B",
            gate: "B8"
        ),
        aircraft: AircraftInfo(
            registration: "N123AA",
            iata: "B738",
            icao: "B738",
            icao24: "A0B1C2"
        ),
        live: LiveData(
            updated: "2024-01-15T15:30:00+0000",
            latitude: 34.0522,
            longitude: -118.2437,
            altitude: 35000,
            direction: 270,
            speedHorizontal: 550,
            speedVertical: 0,
            isGround: false
        )
    )
}

