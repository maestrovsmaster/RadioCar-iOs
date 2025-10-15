//
//  StationCache.swift
//  RadioCar
//
//  Created by Maestro Master on 15/10/2025.
//

import Foundation

/// A dynamic cache for stations with TTL (time-to-live) support
actor StationCache {
    // MARK: - Cache Entry

    private struct CacheEntry {
        let stations: [Station]
        let timestamp: Date

        func isValid(ttl: TimeInterval) -> Bool {
            Date().timeIntervalSince(timestamp) < ttl
        }
    }

    // MARK: - Cache Key

    enum CacheKey: Hashable {
        case country(String, offset: Int, limit: Int)
        case search(String, offset: Int, limit: Int)
        case all

        var description: String {
            switch self {
            case .country(let country, let offset, let limit):
                return "country:\(country)_offset:\(offset)_limit:\(limit)"
            case .search(let term, let offset, let limit):
                return "search:\(term)_offset:\(offset)_limit:\(limit)"
            case .all:
                return "all"
            }
        }
    }

    // MARK: - Properties

    private var cache: [CacheKey: CacheEntry] = [:]
    private let defaultTTL: TimeInterval

    // MARK: - Initialization

    init(defaultTTL: TimeInterval = 1800) { // 30 minutes default
        self.defaultTTL = defaultTTL
    }

    // MARK: - Public Methods

    /// Retrieves cached stations if available and valid
    func get(_ key: CacheKey) -> [Station]? {
        guard let entry = cache[key], entry.isValid(ttl: defaultTTL) else {
            // Remove expired entry
            if cache[key] != nil {
                cache.removeValue(forKey: key)
            }
            return nil
        }

        print("📦 Cache HIT for key: \(key.description)")
        return entry.stations
    }

    /// Stores stations in cache with current timestamp
    func set(_ key: CacheKey, stations: [Station]) {
        let entry = CacheEntry(stations: stations, timestamp: Date())
        cache[key] = entry
        print("📦 Cache SET for key: \(key.description) with \(stations.count) stations")
    }

    /// Invalidates a specific cache entry
    func invalidate(_ key: CacheKey) {
        cache.removeValue(forKey: key)
        print("📦 Cache INVALIDATED for key: \(key.description)")
    }

    /// Invalidates all cache entries matching a predicate
    func invalidateMatching(_ predicate: (CacheKey) -> Bool) {
        let keysToRemove = cache.keys.filter(predicate)
        keysToRemove.forEach { cache.removeValue(forKey: $0) }
        print("📦 Cache INVALIDATED \(keysToRemove.count) entries")
    }

    /// Clears all cache entries
    func clear() {
        let count = cache.count
        cache.removeAll()
        print("📦 Cache CLEARED: removed \(count) entries")
    }

    /// Returns the number of cached entries
    func count() -> Int {
        cache.count
    }

    /// Returns cache statistics
    func stats() -> (total: Int, valid: Int, expired: Int) {
        let total = cache.count
        let valid = cache.values.filter { $0.isValid(ttl: defaultTTL) }.count
        let expired = total - valid
        return (total: total, valid: valid, expired: expired)
    }
}
