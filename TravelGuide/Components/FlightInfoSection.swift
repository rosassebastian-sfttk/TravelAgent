//
//  FlightInfoSection.swift
//  TravelGuide
//
//  Created by Sebastian Rosas Maciel on 9/16/25.
//

import SwiftUI

struct FlightInfoSection: View {
    let title: String
    let airport: String
    let iata: String
    let time: String
    let terminal: String?
    let gate: String?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.headline)
                .foregroundColor(.primary)
            
            Text("\(airport) (\(iata))")
                .font(.subheadline)
                .foregroundColor(.primary)
            
            Text(time)
                .font(.caption)
                .foregroundColor(.secondary)
            
            if let terminal = terminal, let gate = gate {
                Text("Terminal \(terminal) • Gate \(gate)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
}
