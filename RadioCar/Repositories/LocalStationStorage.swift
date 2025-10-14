//
//  LocalStationStorage.swift
//  RadioCar
//
//  Created by Maestro Master on 24/06/2025.
//

import Foundation
import SwiftData

protocol LocalStationStorage {
    func saveStations(_ stations: [Station]) async throws
    func getCachedStations() async throws -> [Station]

    // Favorites
    func addToFavorites(stationUuid: String) async throws
    func removeFromFavorites(stationUuid: String) async throws
    func getFavoriteStationUuids() async throws -> [String]
    func isFavorite(stationUuid: String) async throws -> Bool

    // Recent
    func addToRecent(stationUuid: String) async throws
    func removeFromRecent(stationUuid: String) async throws
    func getRecentStationUuids() async throws -> [String]
}

/// UserDefaults-based storage for iOS 15-16 (persists across app restarts)
final class UserDefaultsStationStorage: LocalStationStorage {
    private let defaults = UserDefaults.standard
    private let favoritesKey = "RadioCar.Favorites"
    private let recentKey = "RadioCar.Recent"
    private let stationsCacheKey = "RadioCar.StationsCache"

    init() {
        print("💾 Using UserDefaults storage for iOS 15-16")
    }

    func saveStations(_ stations: [Station]) async throws {
        if let encoded = try? JSONEncoder().encode(stations) {
            defaults.set(encoded, forKey: stationsCacheKey)
            print("💾 Saved \(stations.count) stations to UserDefaults")
        }
    }

    func getCachedStations() async throws -> [Station] {
        guard let data = defaults.data(forKey: stationsCacheKey),
              let stations = try? JSONDecoder().decode([Station].self, from: data) else {
            return []
        }
        print("💾 Loaded \(stations.count) stations from UserDefaults")
        return stations
    }

    // Favorites
    func addToFavorites(stationUuid: String) async throws {
        var favorites = Set(defaults.stringArray(forKey: favoritesKey) ?? [])
        favorites.insert(stationUuid)
        defaults.set(Array(favorites), forKey: favoritesKey)
        print("💾 Added to favorites: \(stationUuid)")
    }

    func removeFromFavorites(stationUuid: String) async throws {
        var favorites = Set(defaults.stringArray(forKey: favoritesKey) ?? [])
        favorites.remove(stationUuid)
        defaults.set(Array(favorites), forKey: favoritesKey)
        print("💾 Removed from favorites: \(stationUuid)")
    }

    func getFavoriteStationUuids() async throws -> [String] {
        let favorites = defaults.stringArray(forKey: favoritesKey) ?? []
        print("💾 Loaded \(favorites.count) favorites from UserDefaults")
        return favorites
    }

    func isFavorite(stationUuid: String) async throws -> Bool {
        let favorites = Set(defaults.stringArray(forKey: favoritesKey) ?? [])
        return favorites.contains(stationUuid)
    }

    // Recent
    func addToRecent(stationUuid: String) async throws {
        var recent = defaults.stringArray(forKey: recentKey) ?? []
        recent.removeAll { $0 == stationUuid }
        recent.insert(stationUuid, at: 0)
        if recent.count > 50 {
            recent = Array(recent.prefix(50))
        }
        defaults.set(recent, forKey: recentKey)
        print("💾 Added to recent: \(stationUuid)")
    }

    func removeFromRecent(stationUuid: String) async throws {
        var recent = defaults.stringArray(forKey: recentKey) ?? []
        recent.removeAll { $0 == stationUuid }
        defaults.set(recent, forKey: recentKey)
        print("💾 Removed from recent: \(stationUuid)")
    }

    func getRecentStationUuids() async throws -> [String] {
        let recent = defaults.stringArray(forKey: recentKey) ?? []
        print("💾 Loaded \(recent.count) recent stations from UserDefaults")
        return recent
    }
}

/// In-memory storage (fallback only, not used by default)
final class InMemoryStationStorage: LocalStationStorage {
    private var cache: [Station] = []
    private var favorites: Set<String> = []
    private var recent: [String] = []

    func saveStations(_ stations: [Station]) async throws {
        cache = stations
    }

    func getCachedStations() async throws -> [Station] {
        return cache
    }

    // Favorites
    func addToFavorites(stationUuid: String) async throws {
        favorites.insert(stationUuid)
    }

    func removeFromFavorites(stationUuid: String) async throws {
        favorites.remove(stationUuid)
    }

    func getFavoriteStationUuids() async throws -> [String] {
        return Array(favorites)
    }

    func isFavorite(stationUuid: String) async throws -> Bool {
        return favorites.contains(stationUuid)
    }

    // Recent
    func addToRecent(stationUuid: String) async throws {
        recent.removeAll { $0 == stationUuid }
        recent.insert(stationUuid, at: 0)
        if recent.count > 50 {
            recent.removeLast()
        }
    }

    func removeFromRecent(stationUuid: String) async throws {
        recent.removeAll { $0 == stationUuid }
    }

    func getRecentStationUuids() async throws -> [String] {
        return recent
    }
}

@available(iOS 17.0, *)
@MainActor
final class SwiftDataStationStorage: LocalStationStorage {
    private let modelContext: ModelContext
    private var cache: [Station] = []

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func saveStations(_ stations: [Station]) async throws {
        cache = stations
    }

    func getCachedStations() async throws -> [Station] {
        return cache
    }

    // Favorites
    func addToFavorites(stationUuid: String) async throws {
        let favorite = FavoriteStation(stationuuid: stationUuid)
        modelContext.insert(favorite)
        try modelContext.save()
    }

    func removeFromFavorites(stationUuid: String) async throws {
        let descriptor = FetchDescriptor<FavoriteStation>(
            predicate: #Predicate { $0.stationuuid == stationUuid }
        )
        let favorites = try modelContext.fetch(descriptor)
        for favorite in favorites {
            modelContext.delete(favorite)
        }
        try modelContext.save()
    }

    func getFavoriteStationUuids() async throws -> [String] {
        let descriptor = FetchDescriptor<FavoriteStation>(
            sortBy: [SortDescriptor(\.addedTime, order: .reverse)]
        )
        let favorites = try modelContext.fetch(descriptor)
        return favorites.map { $0.stationuuid }
    }

    func isFavorite(stationUuid: String) async throws -> Bool {
        let descriptor = FetchDescriptor<FavoriteStation>(
            predicate: #Predicate { $0.stationuuid == stationUuid }
        )
        let count = try modelContext.fetchCount(descriptor)
        return count > 0
    }

    // Recent
    func addToRecent(stationUuid: String) async throws {
        // Remove existing if present
        let existingDescriptor = FetchDescriptor<RecentStation>(
            predicate: #Predicate { $0.stationuuid == stationUuid }
        )
        let existing = try modelContext.fetch(existingDescriptor)
        for item in existing {
            modelContext.delete(item)
        }

        // Add new
        let recent = RecentStation(stationuuid: stationUuid)
        modelContext.insert(recent)

        // Keep only last 50
        let allDescriptor = FetchDescriptor<RecentStation>(
            sortBy: [SortDescriptor(\.lastPlayedTime, order: .reverse)]
        )
        let allRecent = try modelContext.fetch(allDescriptor)
        if allRecent.count > 50 {
            for item in allRecent.dropFirst(50) {
                modelContext.delete(item)
            }
        }

        try modelContext.save()
    }

    func removeFromRecent(stationUuid: String) async throws {
        let descriptor = FetchDescriptor<RecentStation>(
            predicate: #Predicate { $0.stationuuid == stationUuid }
        )
        let recents = try modelContext.fetch(descriptor)
        for recent in recents {
            modelContext.delete(recent)
        }
        try modelContext.save()
    }

    func getRecentStationUuids() async throws -> [String] {
        let descriptor = FetchDescriptor<RecentStation>(
            sortBy: [SortDescriptor(\.lastPlayedTime, order: .reverse)]
        )
        let recents = try modelContext.fetch(descriptor)
        return recents.map { $0.stationuuid }
    }
}

