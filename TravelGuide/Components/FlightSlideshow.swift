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
        VStack(spacing: 16) {
            ZStack {
                ForEach(flights.indices, id: \.self) { index in
                    if index == currentIndex {
                        FlightDetailsCard(flight: flights[index], removal: {
                            withAnimation(.easeInOut(duration: 0.3)) {
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
                                        withAnimation(.easeInOut(duration: 0.3)) {
                                            if offset.width > 0 {
                                                previousFlight()
                                            } else {
                                                nextFlight()
                                            }
                                        }
                                    } else {
                                        withAnimation(.spring()) {
                                            offset = .zero
                                        }
                                    }
                                }
                        )
                    }
                }
            }
            .frame(height: 320)
            HStack(spacing: 6) {
                ForEach(0..<flights.count, id: \.self) { index in
                    RoundedRectangle(cornerRadius: 2)
                        .fill(index == currentIndex ? .primary : .secondary)
                        .frame(width: index == currentIndex ? 16 : 6, height: 6)
                        .animation(.spring(duration: 0.3), value: currentIndex)
                }
            }
            .padding(.bottom)
        }
    }
    
    private func nextFlight() {
        currentIndex = (currentIndex + 1) % flights.count // Loop back to start
        offset = .zero
    }
    
    private func previousFlight() {
        currentIndex = currentIndex == 0 ? flights.count - 1 : currentIndex - 1
        offset = .zero
    }
    
    private func removeCard() {
        if offset.width > 0 {
            previousFlight()
        } else {
            nextFlight()
        }
    }
}
