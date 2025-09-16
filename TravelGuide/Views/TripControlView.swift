//
//  TripControlView.swift
//  TravelGuide
//
//  Created by Sebastian Rosas Maciel on 9/16/25.
//

import SwiftUI

struct TripControlView: View {
    var body: some View {
        HStack {
            VStack {
                FlightStatusCard()
                    .frame(width: 400)
                
                FlightSlideshowView()
                    .frame(width: 400)
            }
            .padding(.horizontal,16)
            .padding(.vertical, 16)
            
            DFWIndoorMapView()
                .clipShape(RoundedRectangle(cornerRadius: 40))
                .padding(.trailing,16)
                .padding(.vertical,16)
            
        }
    }
}

#Preview(windowStyle: .automatic) {
    TripControlView()
}
