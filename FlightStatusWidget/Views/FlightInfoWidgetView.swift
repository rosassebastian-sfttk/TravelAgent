//
//  FlightInfoWidgetView.swift
//  TravelGuide
//
//  Created by Sebastian Rosas Maciel on 9/15/25.
//

import SwiftUI
import MapKit
import WidgetKit

struct FlightInfoWidgetView: View {
    var flight: Flight
    @Environment(\.widgetFamily) var family
    
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
        ZStack {
            // Fondo con gradiente según estado
            statusGradient(status)
            
            VStack(alignment: .leading, spacing: 8) {
                // Header con info del vuelo
                HStack {
                    VStack(alignment: .leading) {
                        Text("\(flight.departure?.iata ?? "---") → \(flight.arrival?.iata ?? "---")")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Text(flight.flight?.iata ?? "AA---")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.8))
                    }
                    
                    Spacer()
                    
                    Text(status.rawValue)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(status.color.opacity(0.8))
                        .cornerRadius(6)
                }
                
                // Información del avión
                HStack {
                    Image(systemName: "airplane")
                        .foregroundColor(.white)
                    
                    Text(flight.aircraft?.iata ?? "B738")
                        .font(.caption)
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    if let gate = flight.departure?.gate {
                        Text("Puerta \(gate)")
                            .font(.caption)
                            .foregroundColor(.white)
                    }
                }
                
                // Hora de salida
                if let scheduledTime = flight.departure?.scheduled?.toDate() {
                    HStack {
                        Image(systemName: "clock")
                            .foregroundColor(.white)
                        
                        Text("Boarding: \(scheduledTime.addingTimeInterval(-30 * 60), style: .time)")
                            .font(.caption)
                            .foregroundColor(.white)
                    }
                }
                
                Spacer()
                
                // Imagen del avión (solo visible en tamaños que lo permitan)
                if family != .systemSmall {
                    Image(systemName: status == .active ? "airplane" : "airplane.arrival")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 40)
                        .foregroundColor(.white)
                        .padding(.top)
                }
            }
            .padding()
        }
    }
    
    func statusGradient(_ status: FlightStatus) -> LinearGradient {
        switch status {
        case .active:
            return LinearGradient(
                gradient: Gradient(colors: [.blue, .purple]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .landed:
            return LinearGradient(
                gradient: Gradient(colors: [.green, .blue]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .scheduled:
            return LinearGradient(
                gradient: Gradient(colors: [.orange, .red]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        default:
            return LinearGradient(
                gradient: Gradient(colors: [.gray, .black]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }
}
