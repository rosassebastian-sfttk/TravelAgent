//
//  AppIntent.swift
//  FlightStatusWidget
//
//  Created by Sebastian Rosas Maciel on 9/15/25.
//

import WidgetKit
import AppIntents

struct ConfigurationAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource { "Configurar Vuelo" }
    static var description: IntentDescription { "Selecciona el número de vuelo a monitorear" }
    
    @Parameter(title: "Número de Vuelo", default: "AA123")
    var flightNumber: String
}
