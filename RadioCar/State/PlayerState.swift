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
    @Published var currentStationGroup: StationGroup?
    @Published var isPlaying: Bool = false
    @Published var isBuffering: Bool = false
    @Published var stationList: [Station] = []
    @Published var stationGroups: [StationGroup] = []

    @Published var songMetadata: String?
    @Published var volume: Float = 1.0
    @Published var isFavorite: Bool = false

    private init() {}

    // MARK: - Last Station Management

    /// Load the last played station from cache and optionally start playback
    /// - Parameter autoplay: Whether to automatically start playing the station
    func loadLastStation(autoplay: Bool) {
        guard let station = LastStationCache.shared.loadLastStation() else {
            return
        }

        let stationGroup = LastStationCache.shared.loadLastStationGroup()

        // Set current station and group without triggering playback
        currentStation = station
        currentStationGroup = stationGroup

        // Only play if autoplay is enabled
        if autoplay {
            playStation(station)
        }
    }

    func setStations(_ stations: [Station]) {
        self.stationList = stations
    }

    func setStationGroups(_ groups: [StationGroup]) {
        self.stationGroups = groups
    }

    func playStationGroup(_ group: StationGroup) {
        currentStationGroup = group
        // Play first stream in group
        if let firstStation = group.stations.first {
            playStation(firstStation)
        }

        // Save to cache
        LastStationCache.shared.saveLastStation(currentStation, stationGroup: group)
    }

    func playStation(_ station: Station) {
        if currentStation?.id != station.id {
            currentStation = station
            // Clear previous metadata
            songMetadata = nil
        }
        // Set buffering state - actual play state will be set by AudioPlayerManager
        isBuffering = true
        isPlaying = false

        // Start fetching metadata
        if let urlString = station.url_resolved ?? station.url,
           let stationUrl = URL(string: urlString) {
            ICYMetadataFetcher.shared.fetchMetadata(from: stationUrl)
        }

        // Save to cache
        LastStationCache.shared.saveLastStation(station, stationGroup: currentStationGroup)
    }

    func pause() {
        isPlaying = false
        isBuffering = false
    }

    func stop() {
        isPlaying = false
        isBuffering = false
        currentStation = nil
        songMetadata = nil
        ICYMetadataFetcher.shared.stopFetching()
    }

    func playNext() {
        if !stationGroups.isEmpty {
            guard let currentGroup = currentStationGroup,
                  let currentIndex = stationGroups.firstIndex(where: { $0.id == currentGroup.id }) else {
                // Play first group if no current
                if let firstGroup = stationGroups.first {
                    playStationGroup(firstGroup)
                }
                return
            }

            let nextIndex = (currentIndex + 1) % stationGroups.count
            playStationGroup(stationGroups[nextIndex])
        } else if !stationList.isEmpty {
            // Fallback to old station list behavior
            guard let current = currentStation,
                  let index = stationList.firstIndex(where: { $0.id == current.id }) else {
                return
            }

            let nextIndex = (index + 1) % stationList.count
            playStation(stationList[nextIndex])
        }
    }

    func playPrevious() {
        if !stationGroups.isEmpty {
            guard let currentGroup = currentStationGroup,
                  let currentIndex = stationGroups.firstIndex(where: { $0.id == currentGroup.id }) else {
                // Play last group if no current
                if let lastGroup = stationGroups.last {
                    playStationGroup(lastGroup)
                }
                return
            }

            let previousIndex = (currentIndex - 1 + stationGroups.count) % stationGroups.count
            playStationGroup(stationGroups[previousIndex])
        } else if !stationList.isEmpty {
            // Fallback to old station list behavior
            guard let current = currentStation,
                  let index = stationList.firstIndex(where: { $0.id == current.id }) else {
                return
            }

            let previousIndex = (index - 1 + stationList.count) % stationList.count
            playStation(stationList[previousIndex])
        }
    }

    func updateFavoriteStatus(isFavorite: Bool) {
        self.isFavorite = isFavorite
        // Update current station group favorite status
        if var currentGroup = currentStationGroup {
            currentGroup.isFavorite = isFavorite
            self.currentStationGroup = currentGroup

            // Also update in stationGroups array
            if let index = stationGroups.firstIndex(where: { $0.id == currentGroup.id }) {
                stationGroups[index].isFavorite = isFavorite
            }
        }
    }
}

