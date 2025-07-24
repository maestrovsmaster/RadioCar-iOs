//
//  StationRepository.swift
//  RadioCar
//
//  Created by Maestro Master on 24/06/2025.
//
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
    
    // додаткові методи для роботи з локальними даними
    func saveStations(_ stations: [Station]) async throws
    func getCachedStations() async throws -> [Station]
}

