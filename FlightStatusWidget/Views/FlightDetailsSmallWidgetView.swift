//
//  FlightDetailsSmallWidgetView.swift
//  TravelGuide
//
//  Created by Sebastian Presno Alvarado  on 16/09/25.
//

import SwiftUI
import WidgetKit

struct SmallFlightWidgetView: View {
    let flight: Flight
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
        VStack(alignment: .leading, spacing: 8) {
            //  section with airplane icon and flight info
            HStack(alignment: .top) {
                Image("UALogo-small")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 40)
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 2) {
                    Text(flight.arrival?.iata ?? "DFW")
                        .foregroundStyle(.primary)
                        .font(.title2)
                        .fontWeight(.medium)
                        .widgetAccentable()
                    
                    Text("UA123")
                        .foregroundStyle(.secondary)
                        .font(.caption)
                        .widgetAccentable(false)
                }
            }
            
           
            VStack(alignment: .leading, spacing: 4) {
                // Status with icon
                Label(status.rawValue, systemImage: "airplane")
                    .font(.caption)
                    .foregroundStyle(.green)
                    .widgetAccentable()
                
                // Time section
                if let scheduledTime = flight.departure?.scheduled?.toDate() {
                    Label("\(scheduledTime.addingTimeInterval(-30 * 60), style: .time)", systemImage: "clock")
                        .font(.caption)
                        .foregroundStyle(.primary)
                        .widgetAccentable(false)
                }
                Label("Puerta \(flight.departure?.gate ?? "—")", systemImage: "door.left.hand.open")
                    .font(.caption)
                    .foregroundStyle(.primary)
                    .widgetAccentable(false)
            }
            
            Spacer()
        }
        .padding()
        // Conditional background based on rendering mode
        .if(widgetRenderingMode == .fullColor) { view in
            view.containerBackground(for: .widget) {
                Color.white
            }
        }
    }
}

// Helper extension for conditional view modifiers
extension View {
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}
