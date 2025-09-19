//
//  TripControlView.swift
//  TravelGuide
//
//  Created by Sebastian Rosas Maciel on 9/16/25.
//

import SwiftUI
import MapKit

struct TripControlView: View {
    @State private var searchText = ""
    
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
            
            VStack {
                HStack {
                    Image(systemName: "magnifyingglass")
                    TextField("Search in DFW (ej. restrooms, restaurants...)", text: $searchText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                .padding(.top, 16)
                .padding(.horizontal, 16)
                
                DFWIndoorMapView(searchQuery: searchText)
                    .clipShape(RoundedRectangle(cornerRadius: 40))
                    .padding(.horizontal,16)
                    .padding(.vertical,16)
            }
            .background(.ultraThickMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 40))
            .padding(.trailing,16)
            .padding(.vertical,16)
        }
    }
}

#Preview(windowStyle: .automatic) {
    TripControlView()
}
