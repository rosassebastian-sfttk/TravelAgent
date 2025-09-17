//
//  FlightStatusWidget.swift
//  FlightStatusWidget
//
//  Created by Sebastian Rosas Maciel on 9/15/25.
//

import WidgetKit
import SwiftUI
import AppIntents

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> FlightEntry {
        FlightEntry(date: Date(), flight: MockData.flight, configuration: ConfigurationAppIntent(), mapImage: nil, slideIndex: 0)
    }
    
    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> FlightEntry {
        let flight = MockData.flight
        let image = await snapshotMap(for: flight)
        return FlightEntry(date: Date(), flight: flight, configuration: configuration, mapImage: image, slideIndex: 0)
    }

    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<FlightEntry> {
        var entries: [FlightEntry] = []
        let currentDate = Date()

        let flight = await fetchFlightData(flightNumber: configuration.flightNumber) ?? MockData.flight
        let image = await snapshotMap(for: flight)

        // Slide 0 (detalles)
        let entry1 = FlightEntry(
            date: currentDate,
            flight: flight,
            configuration: configuration,
            mapImage: image,
            slideIndex: 0
        )
        entries.append(entry1)

        // Slide 1 (mapa) -> aparece 30s después
        let entry2 = FlightEntry(
            date: Calendar.current.date(byAdding: .second, value: 30, to: currentDate)!,
            flight: flight,
            configuration: configuration,
            mapImage: image,
            slideIndex: 1
        )
        entries.append(entry2)

        // Repetir slideshow cada minuto
        let nextUpdate = Calendar.current.date(byAdding: .minute, value: 1, to: currentDate)!

        return Timeline(entries: entries, policy: .after(nextUpdate))
    }


    
    private func fetchFlightData(flightNumber: String) async -> Flight? {
        // Implementar llamada a Aviationstack API
        // Por ahora retornamos mock data
        return MockData.flight
    }
}

struct FlightEntry: TimelineEntry {
    let date: Date
    let flight: Flight
    let configuration: ConfigurationAppIntent
    let mapImage: UIImage?
    let slideIndex: Int   // <- 0 = detalles, 1 = mapa
}

struct FlightStatusWidgetEntryView: View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var family

    var body: some View {
        switch family {
        case .systemSmall:
            SmallFlightWidgetView(flight: entry.flight)

        case .systemMedium:
//            if entry.slideIndex == 0 {
            FlightDetailsMediumWidgetView(flight: entry.flight)
//            } else {
//                FlightMapWidgetView(flight: entry.flight, mapImage: entry.mapImage)
//            }

        default:
            SmallFlightWidgetView(flight: entry.flight)
        }
    }
}



struct FlightStatusWidget: Widget {
    let kind: String = "FlightStatusWidget"
    
    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            FlightStatusWidgetEntryView(entry: entry)
        }
        .supportedFamilies([.systemSmall, .systemMedium])
        .configurationDisplayName("Estado de Vuelo")
        .description("Monitorea el progreso de tu próximo vuelo")
    }
}

// Extensión para parsear fechas


// Extensión para formatear horas
extension Date {
    func flightTimeFormat() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: self)
    }
}

import MapKit

extension Provider {
    func snapshotMap(for flight: Flight) async -> UIImage? {
        // Definir región del mapa según la posición del vuelo
        // Aquí puedes personalizar: origen/destino, coordenadas reales, etc.
        let region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 40.7128, longitude: -74.0060), // Ejemplo: NYC
            span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
        )

        let options = MKMapSnapshotter.Options()
        options.region = region
        options.size = CGSize(width: 400, height: 200) // Ajusta al tamaño del widget
        options.scale = 2.0

        let snapshotter = MKMapSnapshotter(options: options)
        do {
            let snapshot = try await snapshotter.start()
            return snapshot.image
        } catch {
            print("Error creando snapshot: \(error)")
            return nil
        }
    }
}
