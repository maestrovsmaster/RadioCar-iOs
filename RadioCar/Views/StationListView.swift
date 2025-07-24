//
//  StationListView.swift
//  RadioCar
//
//  Created by Maestro Master on 24/07/2025.
//
import SwiftUI

struct StationListView: View {
    @ObservedObject var playerState = PlayerState.shared
    let stations: [Station]
    
    var body: some View {
        List(stations) { station in
            HStack {
                Text(station.name ?? "")
                Spacer()
                if playerState.currentStation?.id == station.id && playerState.isPlaying {
                    Image(systemName: "speaker.wave.2.fill")
                }
            }
            .contentShape(Rectangle())
            .onTapGesture {
                PlayerState.shared.playStation(station)
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .nextTrackRequested)) { _ in
            playNextStation()
        }
        .onReceive(NotificationCenter.default.publisher(for: .previousTrackRequested)) { _ in
            playPreviousStation()
        }
    }
    
    private func playNextStation() {
        guard let current = playerState.currentStation,
              let currentIndex = stations.firstIndex(where: { $0.id == current.id }) else { return }
        
        let nextIndex = (currentIndex + 1) % stations.count
        PlayerState.shared.playStation(stations[nextIndex])
    }
    
    private func playPreviousStation() {
        guard let current = playerState.currentStation,
              let currentIndex = stations.firstIndex(where: { $0.id == current.id }) else { return }
        
        let prevIndex = (currentIndex - 1 + stations.count) % stations.count
        PlayerState.shared.playStation(stations[prevIndex])
    }
}

