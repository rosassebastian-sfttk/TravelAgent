//
//  ContentView.swift
//  TravelGuide
//
//  Created by Sebastian Rosas Maciel on 9/15/25.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {
// d89f779d1ead3317c7b01937565854f4
    var body: some View {
        TripControlView()
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
        .environment(AppModel())
}
