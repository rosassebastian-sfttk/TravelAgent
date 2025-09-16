//
//  SwiftUIView.swift
//  TravelGuide
//
//  Created by Sebastian Rosas Maciel on 9/15/25.
//

import SwiftUI
import WidgetKit

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
                    Label("Puerta \(flight.departure?.gate ?? "—")", systemImage: "door.left.hand.open")
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
