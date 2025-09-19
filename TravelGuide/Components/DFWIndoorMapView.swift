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
    
    static let userDFWLocation = CLLocationCoordinate2D(
        latitude: 32.8998,
        longitude: -97.0403
    )
}

struct DFWIndoorMapView: View {
    var searchQuery: String
    
    @State private var position: MapCameraPosition = .automatic
    @State private var pointsOfInterest: [MKMapItem] = []
    @State private var selectedPOI: MKMapItem?
    @State private var selection: MKMapItem?
    @State private var route: MKRoute?
    @State private var isCalculatingRoute = false
    
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
        Map(position: $position, selection: $selection) {
            Marker("You", coordinate: CLLocationCoordinate2D.userDFWLocation)
                .tint(.green)
            
            ForEach(pointsOfInterest, id: \.self) { poi in
                Marker(poi.name ?? "POI", coordinate: poi.placemark.coordinate)
                    .tint(.red)
                    .tag(poi)
                    .annotationTitles(.visible)
            }
            
            if let route = route {
                MapPolyline(route.polyline)
                    .stroke(.blue, lineWidth: 4)
            }
        }
        .onChange(of: selection) { _, newSelection in
            if newSelection == nil {
                route = nil
            }
        }
        .mapStyle(.standard(elevation: .flat))
        .mapControls {
            MapCompass()
            MapPitchToggle()
        }
        .onAppear {
            position = .region(MKCoordinateRegion(
                center: .dfwAirport,
                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            ))
        }
        .onChange(of: searchQuery) { _, newValue in
            if !newValue.isEmpty {
                searchPOIs(query: newValue)
            } else {
                pointsOfInterest = []
                route = nil
                selection = nil
            }
        }
        .overlay {
            if isCalculatingRoute {
                ProgressView("Calculating route...")
                    .padding()
                    .background(.regularMaterial)
                    .cornerRadius(8)
            }
        }
    }
    
    private func searchPOIs(query: String) {
        var request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        
        // Región pequeña alrededor de DFW
        request.region = MKCoordinateRegion(
            center: .dfwAirport,
            span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02) // 🔒 solo aeropuerto
        )
        
        let search = MKLocalSearch(request: request)
        search.start { response, error in
            if let error = error {
                print("Error en búsqueda: \(error.localizedDescription)")
                return
            }
            
            if let items = response?.mapItems {
                let maxDistance: CLLocationDistance = 2000 // 2 km desde el centro del aeropuerto
                pointsOfInterest = items.filter {
                    $0.placemark.coordinate.distance(to: .dfwAirport) <= maxDistance
                }
                
                if let closest = pointsOfInterest.min(by: { lhs, rhs in
                    lhs.placemark.coordinate.distance(to: .userDFWLocation) <
                        rhs.placemark.coordinate.distance(to: .userDFWLocation)
                }) {
                    selectedPOI = closest
                    selectPOI(closest)
                } else {
                    route = nil
                }
            } else {
                pointsOfInterest = []
                route = nil
            }
        }
    }
    
    
    
    private func selectPOI(_ poi: MKMapItem) {
        selectedPOI = poi
        isCalculatingRoute = true
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D.userDFWLocation))
        request.destination = poi
        request.transportType = .any
        
        let directions = MKDirections(request: request)
        directions.calculate { response, error in
            isCalculatingRoute = false
            
            if let error = error {
                print("Error calculando ruta: \(error.localizedDescription)")
                return
            }
            
            guard let route = response?.routes.first else {
                print("No se encontró ruta")
                return
            }
            
            self.route = route
            
            adjustCameraToShowRoute(route)
        }
    }
    
    private func adjustCameraToShowRoute(_ route: MKRoute) {
        guard let poi = selectedPOI else { return }
        
        let distance = CLLocationCoordinate2D.userDFWLocation.distance(to: poi.placemark.coordinate)
        
        let spanDelta = max(distance / 500.0 * 0.01, 0.005)
        
        let region = MKCoordinateRegion(
            center: CLLocationCoordinate2D.userDFWLocation,
            span: MKCoordinateSpan(latitudeDelta: spanDelta, longitudeDelta: spanDelta)
        )
        
        position = .region(region)
    }
    
}

#Preview {
    DFWIndoorMapView(searchQuery: "restroom")
}

extension CLLocationCoordinate2D {
    func distance(to other: CLLocationCoordinate2D) -> CLLocationDistance {
        let loc1 = CLLocation(latitude: latitude, longitude: longitude)
        let loc2 = CLLocation(latitude: other.latitude, longitude: other.longitude)
        return loc1.distance(from: loc2)
    }
}

