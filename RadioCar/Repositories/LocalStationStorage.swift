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

