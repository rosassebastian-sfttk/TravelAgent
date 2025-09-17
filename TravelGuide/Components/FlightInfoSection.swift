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
    
    private var formattedTime: String {
        if let colonIndex = time.firstIndex(of: " ") {
            let timeOnly = String(time[time.index(after: colonIndex)...])
            return timeOnly.prefix(5).description
        }
        return time
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
                .textCase(.uppercase)
                .tracking(0.5)
            
            Text(iata)
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundStyle(.primary)
            
            Text(formattedTime)
                .font(.subheadline)
                .foregroundStyle(.primary)
            
            Text(airport)
                .font(.caption)
                .foregroundStyle(.secondary)
                .lineLimit(2)
                .multilineTextAlignment(.leading)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
