//
//  StationRepository.swift
//  RadioCar
//
//  Created by Maestro Master on 24/07/2025.
//

import Foundation

final class DefaultStationRepository: StationRepository {
    private let remote: RadioAPIService
    private let storage: LocalStationStorage
    private let cache = StationCache()
    private var cachedStations: [Station] = []

    init(remote: RadioAPIService, storage: LocalStationStorage = UserDefaultsStationStorage()) {
        self.remote = remote
        self.storage = storage
        print("📦 DefaultStationRepository initialized with \(type(of: storage))")
    }

    func fetchStations(
        country: String,
        offset: Int,
        limit: Int
    ) async throws -> [Station] {
        let cacheKey = StationCache.CacheKey.country(country, offset: offset, limit: limit)

        // Check cache first
        if let cachedStations = await cache.get(cacheKey) {
            self.cachedStations = cachedStations
            return cachedStations
        }

        // Cache miss - fetch from remote
        print("📡 Fetching stations from remote for country: \(country)")
        let stations = try await remote.fetchStations(country: country, offset: offset, limit: limit)

        // Store in cache
        await cache.set(cacheKey, stations: stations)
        self.cachedStations = stations

        return stations
    }

    func fetchStationsByName(
        searchTerm: String,
        offset: Int,
        limit: Int
    ) async throws -> [Station] {
        let cacheKey = StationCache.CacheKey.search(searchTerm, offset: offset, limit: limit)

        // Check cache first
        if let cachedStations = await cache.get(cacheKey) {
            self.cachedStations = cachedStations
            return cachedStations
        }

        // Cache miss - fetch from remote
        print("📡 Fetching stations from remote for search: \(searchTerm)")
        let stations = try await remote.fetchStationsByName(searchTerm: searchTerm, offset: offset, limit: limit)

        // Store in cache
        await cache.set(cacheKey, stations: stations)
        self.cachedStations = stations

        return stations
    }

    func fetchStationGroups(
        country: String,
        offset: Int,
        limit: Int
    ) async throws -> [StationGroup] {
        let stations = try await fetchStations(country: country, offset: offset, limit: limit)
        let filteredStations = StationFilters.filterStations(stations)
        return await groupStations(filteredStations)
    }

    func searchStationGroups(
        query: String,
        country: String,
        tag: String,
        offset: Int,
        limit: Int
    ) async throws -> [StationGroup] {
        let cacheKey = StationCache.CacheKey.search(
            "\(query)-\(country)-\(tag)",
            offset: offset,
            limit: limit
        )

        // Check cache first
        if let cachedStations = await cache.get(cacheKey) {
            let filteredStations = StationFilters.filterStations(cachedStations)
            return await groupStations(filteredStations)
        }

        // Cache miss - fetch from remote
        print("📡 Searching stations: query=\(query), country=\(country), tag=\(tag)")
        let stations = try await remote.fetchStationsExt(
            country: country,
            name: query,
            tag: tag,
            offset: offset,
            limit: limit
        )

        // Apply filters before caching and grouping
        let filteredStations = StationFilters.filterStations(stations)

        // Store in cache
        await cache.set(cacheKey, stations: filteredStations)

        return await groupStations(filteredStations)
    }

    func getFavoriteStationGroups() async throws -> [StationGroup] {
        let favoriteUuids = try await storage.getFavoriteStationUuids()
        let favoriteStations = cachedStations.filter { station in
            guard let uuid = station.stationuuid else { return false }
            return favoriteUuids.contains(uuid)
        }
        return await groupStations(favoriteStations)
    }

    func getRecentStationGroups() async throws -> [StationGroup] {
        let recentUuids = try await storage.getRecentStationUuids()
        let recentStations = cachedStations.filter { station in
            guard let uuid = station.stationuuid else { return false }
            return recentUuids.contains(uuid)
        }
        // Sort by recent order
        let sortedStations = recentStations.sorted { station1, station2 in
            guard let uuid1 = station1.stationuuid, let uuid2 = station2.stationuuid else { return false }
            guard let index1 = recentUuids.firstIndex(of: uuid1),
                  let index2 = recentUuids.firstIndex(of: uuid2) else { return false }
            return index1 < index2
        }
        return await groupStations(sortedStations)
    }

    func addToFavorites(stationUuid: String) async throws {
        try await storage.addToFavorites(stationUuid: stationUuid)
    }

    func removeFromFavorites(stationUuid: String) async throws {
        try await storage.removeFromFavorites(stationUuid: stationUuid)
    }

    func isFavorite(stationUuid: String) async throws -> Bool {
        try await storage.isFavorite(stationUuid: stationUuid)
    }

    func addToRecent(stationUuid: String) async throws {
        try await storage.addToRecent(stationUuid: stationUuid)
    }

    func removeFromRecent(stationUuid: String) async throws {
        try await storage.removeFromRecent(stationUuid: stationUuid)
    }

    func saveStations(_ stations: [Station]) async throws {
        self.cachedStations = stations
        try await storage.saveStations(stations)
    }

    func getCachedStations() async throws -> [Station] {
        return cachedStations
    }

    // MARK: - Cache Management

    /// Clears all cached station data
    func clearCache() async {
        await cache.clear()
        cachedStations = []
    }

    /// Invalidates cache for a specific country
    func invalidateCacheForCountry(_ country: String) async {
        await cache.invalidateMatching { key in
            if case .country(let cachedCountry, _, _) = key {
                return cachedCountry == country
            }
            return false
        }
    }

    /// Returns cache statistics
    func getCacheStats() async -> (total: Int, valid: Int, expired: Int) {
        await cache.stats()
    }

    // MARK: - Private Helpers

    private func groupStations(_ stations: [Station]) async -> [StationGroup] {
        let grouped = Dictionary(grouping: stations) { $0.name ?? "Unknown" }

        var groups: [StationGroup] = []

        for (name, stationsInGroup) in grouped {
            let streams = stationsInGroup.map { station in
                StationStream(
                    stationUuid: station.stationuuid ?? UUID().uuidString,
                    url: station.url_resolved ?? station.url ?? "",
                    bitrate: station.bitrate ?? 128
                )
            }

            let favicon = stationsInGroup.first?.favicon ?? ""
            let countryCode = stationsInGroup.first?.countrycode

            // Check if any station in the group is favorite
            var isFavorite = false
            if let firstUuid = stationsInGroup.first?.stationuuid {
                isFavorite = (try? await storage.isFavorite(stationUuid: firstUuid)) ?? false
            }

            let group = StationGroup(
                name: name,
                streams: streams,
                stations: stationsInGroup,
                favicon: favicon,
                isFavorite: isFavorite,
                countryCode: countryCode
            )
            groups.append(group)
        }

        return groups.sorted { $0.name < $1.name }
    }
}
