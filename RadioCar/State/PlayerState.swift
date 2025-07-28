//
//  PlayerState.swift
//  RadioCar
//
//  Created by Maestro Master on 24/07/2025.
//
import Foundation
import Combine
import AVFoundation


final class PlayerState: ObservableObject {
    static let shared = PlayerState()

    @Published var currentStation: Station?
    @Published var isPlaying: Bool = false
    @Published var stationList: [Station] = []
    
    @Published var songMetadata: String?

    private init() {}

    func setStations(_ stations: [Station]) {
        self.stationList = stations
    }

    func playStation(_ station: Station) {
        if currentStation?.id != station.id {
            currentStation = station
        }
        isPlaying = true
        
        if let urlString = station.url, let stationUrl = URL(string: urlString) {
            //ICYMetadataFetcher.shared.fetchMetadata(from: stationUrl)
        }

    }

    func pause() {
        isPlaying = false
    }

    func stop() {
        isPlaying = false
        currentStation = nil
    }

    func playNext() {
        guard let current = currentStation,
              let index = stationList.firstIndex(where: { $0.id == current.id }) else {
            return
        }

        let nextIndex = (index + 1) % stationList.count
        playStation(stationList[nextIndex])
    }

    func playPrevious() {
        guard let current = currentStation,
              let index = stationList.firstIndex(where: { $0.id == current.id }) else {
            return
        }

        let previousIndex = (index - 1 + stationList.count) % stationList.count
        playStation(stationList[previousIndex])
    }
}

