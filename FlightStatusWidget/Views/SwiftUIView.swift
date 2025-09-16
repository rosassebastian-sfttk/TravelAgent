//
//  SwiftUIView.swift
//  TravelGuide
//
//  Created by Sebastian Rosas Maciel on 9/15/25.
//

import SwiftUI

struct FlightDetailsWidgetView: View {
    var flight: Flight
    
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
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("UA123")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                Image("UALogo")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 50)
                
                Spacer()
                
                Text(status.rawValue)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.green.opacity(0.2))
                    .clipShape(Capsule())
            }
            
            Divider()
            
            // Detalle en dos columnas
            HStack(alignment: .top, spacing: 24) {
                VStack(alignment: .leading, spacing: 6) {
                    Label("Puerta \(flight.departure?.gate ?? "—")", systemImage: "door.left.hand.open")
                        .font(.caption)
                    Label("Terminal \(flight.departure?.terminal ?? "—")", systemImage: "building.2")
                        .font(.caption)
                }
                
                
                
                if let scheduledTime = flight.departure?.scheduled?.toDate() {
                    HStack {
                        Image(systemName: "clock")
                            .foregroundColor(.white)
                        
                        Text("Abordaje: \(scheduledTime.addingTimeInterval(-30 * 60), style: .time)")
                            .font(.caption)
                            .foregroundColor(.white)
                    }
                }
                
                HStack {
                    Image(systemName: "airplane")
                        .foregroundColor(.white)
                    
                    Text(flight.aircraft?.iata ?? "B738")
                        .font(.caption)
                        .foregroundColor(.white)
                }
                
            
            }
        }
        .padding()
    }
}

extension String {
    func toDate() -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return formatter.date(from: self)
    }
}
