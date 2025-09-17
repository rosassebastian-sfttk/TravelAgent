//
//  FlightSlideshow.swift
//  TravelGuide
//
//  Created by Sebastian Rosas Maciel on 9/16/25.
//

import SwiftUI

struct FlightSlideshow: View {
    let flights: [AVStackFlight]
    @State private var currentIndex = 0
    @State private var offset = CGSize.zero
    
    var body: some View {
        VStack {
            ZStack {
                ForEach(flights.indices, id: \.self) { index in
                    if index == currentIndex {
                        FlightDetailsCard(flight: flights[index], removal: {
                            withAnimation {
                                removeCard()
                            }
                        })
                        .offset(x: offset.width, y: 0)
                        .rotationEffect(.degrees(Double(offset.width / 40)))
                        .opacity(2 - Double(abs(offset.width / 50)))
                        .gesture(
                            DragGesture()
                                .onChanged { gesture in
                                    offset = gesture.translation
                                }
                                .onEnded { _ in
                                    if abs(offset.width) > 100 {
                                        withAnimation {
                                            if offset.width > 0 {
                                                previousFlight()
                                            } else {
                                                nextFlight()
                                            }
                                        }
                                    } else {
                                        withAnimation {
                                            offset = .zero
                                        }
                                    }
                                }
                        )
                    }
                }
            }
            .frame(height: 300)
            
            HStack(spacing: 8) {
                ForEach(0..<flights.count, id: \.self) { index in
                    Circle()
                        .fill(index == currentIndex ? Color.blue : Color.gray.opacity(0.3))
                        .frame(width: 8, height: 8)
                }
            }
            .padding()
        }
    }
    
    private func nextFlight() {
        withAnimation(.easeInOut(duration: 0.3)) {
            currentIndex = min(currentIndex + 1, flights.count - 1)
            offset = .zero
        }
    }
    
    private func previousFlight() {
        withAnimation(.easeInOut(duration: 0.3)) {
            currentIndex = max(currentIndex - 1, 0)
            offset = .zero
        }
    }
    
    private func removeCard() {
        if offset.width > 0 {
            previousFlight()
        } else {
            nextFlight()
        }
    }
}
