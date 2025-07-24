//
//  StationRepository.swift
//  RadioCar
//
//  Created by Maestro Master on 24/07/2025.
//

import Foundation

final class DefaultStationRepository: StationRepository {
    private let remote: RadioAPIService
    private var cachedStations: [Station] = []

    init(remote: RadioAPIService) {
        self.remote = remote
    }

    func fetchStations(
        country: String,
        offset: Int,
        limit: Int
    ) async throws -> [Station] {
        let stations = try await remote.fetchStations(country: country, offset: offset, limit: limit)
        self.cachedStations = stations
        return stations
    }

    func fetchStationsByName(
        searchTerm: String,
        offset: Int,
        limit: Int
    ) async throws -> [Station] {
        let stations = try await remote.fetchStationsByName(searchTerm: searchTerm, offset: offset, limit: limit)
        self.cachedStations = stations
        return stations
    }

    func saveStations(_ stations: [Station]) async throws {
        // Ти можеш реалізувати збереження у файл, UserDefaults або SwiftData/CoreData
        self.cachedStations = stations
    }

    func getCachedStations() async throws -> [Station] {
        return cachedStations
    }
}
