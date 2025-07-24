//
//  StationRepositoryImpl.swift
//  RadioCar
//
//  Created by Maestro Master on 24/06/2025.
//
/*
final class StationRepositoryImpl: StationRepository {
    private let networkService: StationServiceImpl
    private let localStorage: LocalStationStorage // твоя локальна база даних, наприклад Core Data, SwiftData чи UserDefaults

    init(networkService: StationServiceImpl, localStorage: LocalStationStorage) {
        self.networkService = networkService
        self.localStorage = localStorage
    }

    func fetchStations(country: String, offset: Int = 0, limit: Int = 200) async throws -> [Station] {
        do {
            let stations = try await networkService.getStations(country: country, offset: offset, limit: limit)
            try await localStorage.saveStations(stations)
            return stations
        } catch {
            // якщо мережа не працює, повертаємо локальні дані
            return try await localStorage.getCachedStations()
        }
    }

    func fetchStationsByName(searchTerm: String, offset: Int = 0, limit: Int = 200) async throws -> [Station] {
        do {
            let stations = try await networkService.getStationsByName(searchTerm: searchTerm, offset: offset, limit: limit)
            try await localStorage.saveStations(stations)
            return stations
        } catch {
            // fallback на локальне кешування або порожній список
            return try await localStorage.getCachedStations()
        }
    }

    func saveStations(_ stations: [Station]) async throws {
        try await localStorage.saveStations(stations)
    }

    func getCachedStations() async throws -> [Station] {
        return try await localStorage.getCachedStations()
    }
}

*/
