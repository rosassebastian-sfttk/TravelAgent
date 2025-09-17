//
//  FlightStatusCard.swift
//  TravelGuide
//
//  Created by Sebastian Rosas Maciel on 9/16/25.
//
import SwiftUI

struct FlightStatusCard: View {
    @State private var progress: Double = 0.5
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("DFW")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("UA123")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image("UALogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 50)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            
            HStack(spacing: 4) {
                Image(systemName: "clock")
                Text("Arriving in")
                    .foregroundColor(.secondary)
                    .font(.caption)
                Text("60 min")
                    .foregroundColor(.green)
                    .font(.caption)
                    .fontWeight(.semibold)
                
                Spacer()
            }
            
            
            HStack {
                Label("Gate D12", systemImage: "door.left.hand.open")
                    .font(.caption2)
                Label("Terminal D", systemImage: "building.2")
                    .font(.caption2)
                
                Spacer()
            }
            
            ZStack {
                ProgressView(value: progress, total: 1.0)
                    .progressViewStyle(.linear)
                
                Image(systemName: "airplane")
                    .font(.system(size: 14, weight: .bold))
                    .offset(x: (progress - 0.5) * 200)
            }
            .frame(height: 16)
            .padding(.bottom, 8)
        }
        .padding(12)
        .background(.ultraThickMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
    }
}

#Preview {
    FlightStatusCard()
        .frame(width: 400)
}
