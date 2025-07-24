//
//  LocalStationStorage.swift
//  RadioCar
//
//  Created by Maestro Master on 24/06/2025.
//
protocol LocalStationStorage {
    func saveStations(_ stations: [Station]) async throws
    func getCachedStations() async throws -> [Station]
}

final class InMemoryStationStorage: LocalStationStorage {
    private var cache: [Station] = []
    
    func saveStations(_ stations: [Station]) async throws {
        cache = stations
    }
    
    func getCachedStations() async throws -> [Station] {
        return cache
    }
}

