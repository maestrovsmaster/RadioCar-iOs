//
//  StationRepository.swift
//  RadioCar
//
//  Created by Maestro Master on 24/06/2025.
//

import Foundation

enum ListType {
    case all
    case favorites
    case recent
}

protocol StationRepository {
    func fetchStations(
        country: String,
        offset: Int,
        limit: Int
    ) async throws -> [Station]

    func fetchStationsByName(
        searchTerm: String,
        offset: Int,
        limit: Int
    ) async throws -> [Station]

    // Station groups
    func fetchStationGroups(
        country: String,
        offset: Int,
        limit: Int
    ) async throws -> [StationGroup]

    func getFavoriteStationGroups() async throws -> [StationGroup]
    func getRecentStationGroups() async throws -> [StationGroup]

    // Favorites
    func addToFavorites(stationUuid: String) async throws
    func removeFromFavorites(stationUuid: String) async throws
    func isFavorite(stationUuid: String) async throws -> Bool

    // Recent
    func addToRecent(stationUuid: String) async throws
    func removeFromRecent(stationUuid: String) async throws

    // Cache
    func saveStations(_ stations: [Station]) async throws
    func getCachedStations() async throws -> [Station]
}

