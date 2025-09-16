//
//  DFWIndoorMapView.swift
//  TravelGuide
//
//  Created by Sebastian Rosas Maciel on 9/16/25.
//


import SwiftUI
import MapKit

extension CLLocationCoordinate2D {
    static let dfwAirport = CLLocationCoordinate2D(
        latitude: 32.8998,
        longitude: -97.0403
    )
}

struct DFWIndoorMapView: View {
    @State private var position: MapCameraPosition = .camera(
        MapCamera(
            centerCoordinate: .dfwAirport,
            distance: 1000,
            heading: 0,
            pitch: 0
        )
    )
    
    @State private var pointsOfInterest: [MKMapItem] = []
    @State private var visibleRegion: MKCoordinateRegion?
        @State private var selectedPOI: MKMapItem?
        @State private var showDetails = false
    
    private let poiFilter = MKPointOfInterestFilter(including: [
           .airport,
           .restaurant,
           .cafe,
           .bakery,
           .hotel,
           .restroom,
           .store,
       ])

    var body: some View {
        Map(position: $position) {
            // Marcador en el aeropuerto DFW
            Marker("DFW Airport", coordinate: .dfwAirport)
                .tint(.blue)
        }
        .mapStyle(.standard(elevation: .flat))
        .mapControls {
            MapCompass() 
            MapPitchToggle()
            MapUserLocationButton()
        }
        .onAppear {

            position = .region(MKCoordinateRegion(
                center: .dfwAirport,
                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            ))
        }
    }
}

#Preview {
    DFWIndoorMapView()
}
