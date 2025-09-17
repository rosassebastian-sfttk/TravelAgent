//
//  StatusBadge.swift
//  TravelGuide
//
//  Created by Sebastian Rosas Maciel on 9/16/25.
//

import SwiftUI

struct StatusBadge: View {
    let status: String
    
    var statusColor: Color {
        switch status.lowercased() {
        case "scheduled", "programado":
            return .blue
        case "active", "en vuelo":
            return .green
        case "landed", "aterrizado":
            return .orange
        case "cancelled", "cancelado":
            return .red
        case "diverted", "desviado":
            return .purple
        default:
            return .gray
        }
    }
    
    var body: some View {
        Text(status.uppercased())
            .font(.system(size: 12, weight: .semibold))
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(statusColor.opacity(0.2))
            .foregroundColor(statusColor)
            .cornerRadius(6)
    }
}
