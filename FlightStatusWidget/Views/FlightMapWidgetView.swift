//
//  FlightMapWidgetView.swift
//  TravelGuide
//
//  Created by Sebastian Rosas Maciel on 9/15/25.
//

import SwiftUI
import MapKit

struct FlightMapWidgetView: View {
    let flight: Flight
    let mapImage: UIImage?

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
        ZStack {
            if let mapImage = mapImage {
                Image(uiImage: mapImage)
                    .resizable()
                    .scaledToFill()
                    .clipped()
            } else {
                // Fallback si no hay snapshot
                ZStack {
                    Color.gray.opacity(0.3)
                    Image(systemName: "airplane")
                        .font(.largeTitle)
                        .foregroundColor(.blue)
                }
            }

            VStack {
                    HStack {
                        Spacer()
                        VStack(alignment: .trailing) {
                            // Usuario en la puerta
                            Label("Puerta \(flight.departure?.gate ?? "—")", systemImage: "figure.walk.circle.fill")
                                .font(.caption2)
                                .padding(6)
                                .background(.green.opacity(0.8))
                                .foregroundColor(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 6))

                            // Avión en tierra
                            Label("Avión", systemImage: "airplane.circle.fill")
                                .font(.caption2)
                                .padding(6)
                                .background(.blue.opacity(0.8))
                                .foregroundColor(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 6))
                        }
                    }
                    Spacer()
                }
                .padding()
        }
    }
}


// Vista de mapa del aeropuerto
struct AirportMapView: View {
    var flight: Flight
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 32.8998, longitude: -97.0403),
        span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
    )
    
    var body: some View {
        let annotations = [
            AirportAnnotation(
                coordinate: region.center,
                terminal: flight.departure?.terminal,
                gate: flight.departure?.gate
            )
        ]
        
        return Map(
            coordinateRegion: .constant(region),
            annotationItems: annotations,
            annotationContent: { location in
                MapAnnotation(coordinate: location.coordinate) {
                    VStack(spacing: 4) {
                        ZStack {
                            Image(systemName: "airplane")
                                .foregroundColor(.red)
                                .font(.title3)
                                .padding(8)
                        }
                        .background(.ultraThinMaterial)
                        .clipShape(Circle())
                        .shadow(radius: 3)
                        .overlay(
                            Circle().stroke(Color.red.opacity(0.3), lineWidth: 2)
                        )
                        
                        if let gate = location.gate {
                            Text(gate)
                                .font(.caption2)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(.ultraThinMaterial)
                                .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
                                .shadow(radius: 2)
                        }
                    }
                }
            }
        )
        .disabled(true)
    }
}

// Vista de mapa de ruta
struct FlightRouteMapView: View {
    var departure: CLLocationCoordinate2D
    var arrival: CLLocationCoordinate2D
    var currentLocation: CLLocationCoordinate2D
    var direction: Double? // Agregar dirección como parámetro
    
    var body: some View {
        let center = calculateCenter()
        let span = calculateSpan()
        
        let region = MKCoordinateRegion(
            center: center,
            span: span
        )
        
        return Map(
            coordinateRegion: .constant(region),
            annotationItems: createAnnotations(),
            annotationContent: { item in
                MapAnnotation(coordinate: item.coordinate) {
                    if item.type == .airplane {
                        ZStack {
                            Circle()
                                .fill(Color.blue)
                                .frame(width: 36, height: 36)
                                .background(.ultraThinMaterial)
                                .clipShape(Circle())
                                .shadow(radius: 2)
                                .overlay(
                                    Circle().stroke(Color.blue.opacity(0.4), lineWidth: 2)
                                )
                            
                            Image(systemName: "airplane")
                                .foregroundColor(.white)
                                .font(.title3)
                                .padding(4)
                        }
                        .rotationEffect(.degrees(item.direction ?? 0))
                    } else {
                        Circle()
                            .fill(item.type == .departure ? Color.green : Color.red)
                            .frame(width: 8, height: 8)
                    }
                }
            }
        )
        .disabled(true)
    }
    
    private func calculateCenter() -> CLLocationCoordinate2D {
        let midLat = (departure.latitude + arrival.latitude) / 2
        let midLon = (departure.longitude + arrival.longitude) / 2
        return CLLocationCoordinate2D(latitude: midLat, longitude: midLon)
    }
    
    private func calculateSpan() -> MKCoordinateSpan {
        let latDelta = abs(departure.latitude - arrival.latitude) * 1.5
        let lonDelta = abs(departure.longitude - arrival.longitude) * 1.5
        return MKCoordinateSpan(
            latitudeDelta: max(latDelta, 10),
            longitudeDelta: max(lonDelta, 10)
        )
    }
    
    private func createAnnotations() -> [MapAnnotationItem] {
        var items: [MapAnnotationItem] = [
            MapAnnotationItem(coordinate: departure, type: .departure),
            MapAnnotationItem(coordinate: arrival, type: .arrival)
        ]
        
        if currentLocation.latitude != 0 && currentLocation.longitude != 0 {
            items.append(MapAnnotationItem(
                coordinate: currentLocation,
                type: .airplane,
                direction: direction // Usar el parámetro direction
            ))
        }
        
        return items
    }
}

struct MapAnnotationItem: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
    let type: AnnotationType
    var direction: Double? = nil
}

enum AnnotationType {
    case departure, arrival, airplane
}

struct DefaultMapView: View {
    var body: some View {
        Map(
            coordinateRegion: .constant(MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: 20, longitude: 0),
                span: MKCoordinateSpan(latitudeDelta: 100, longitudeDelta: 100)
            ))
        )
        .disabled(true)
        .overlay(
            VStack {
                Image(systemName: "airplane")
                    .font(.largeTitle)
                    .foregroundColor(.blue)
                    .shadow(radius: 5)
                Text("Esperando datos de vuelo")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .padding()
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            .shadow(radius: 6)
            .padding()
        )
    }
}

