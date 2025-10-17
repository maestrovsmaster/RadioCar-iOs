//
//  LastStationCache.swift
//  RadioCar
//
//  Created by Maestro Master on 17/10/2025.
//

import Foundation

/// Manages persistence of the last played station and station group
final class LastStationCache {
    static let shared = LastStationCache()

    private let defaults = UserDefaults.standard

    // MARK: - Keys

    private enum Keys {
        static let lastStationData = "cache.lastStation"
        static let lastStationGroupData = "cache.lastStationGroup"
    }

    // MARK: - Public Methods

    /// Save the current station and station group to cache
    func saveLastStation(_ station: Station?, stationGroup: StationGroup?) {
        // Save station
        if let station = station {
            if let encoded = try? JSONEncoder().encode(station) {
                defaults.set(encoded, forKey: Keys.lastStationData)
            }
        } else {
            defaults.removeObject(forKey: Keys.lastStationData)
        }

        // Save station group
        if let stationGroup = stationGroup {
            if let encoded = try? JSONEncoder().encode(stationGroup) {
                defaults.set(encoded, forKey: Keys.lastStationGroupData)
            }
        } else {
            defaults.removeObject(forKey: Keys.lastStationGroupData)
        }
    }

    /// Load the last saved station from cache
    func loadLastStation() -> Station? {
        guard let data = defaults.data(forKey: Keys.lastStationData) else {
            return nil
        }

        return try? JSONDecoder().decode(Station.self, from: data)
    }

    /// Load the last saved station group from cache
    func loadLastStationGroup() -> StationGroup? {
        guard let data = defaults.data(forKey: Keys.lastStationGroupData) else {
            return nil
        }

        return try? JSONDecoder().decode(StationGroup.self, from: data)
    }

    /// Clear the saved last station data
    func clearLastStation() {
        defaults.removeObject(forKey: Keys.lastStationData)
        defaults.removeObject(forKey: Keys.lastStationGroupData)
    }

    // MARK: - Initialization

    private init() {}
}
