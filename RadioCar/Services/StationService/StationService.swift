//
//  StationService.swift
//  RadioCar
//
//  Created by Maestro Master on 24/06/2025.
//
import Foundation

protocol StationService {
    func getStationsExt(
        country: String,
        name: String,
        tag: String,
        offset: Int,
        limit: Int
    ) async throws -> [Station]

    func getStations(
        country: String,
        offset: Int,
        limit: Int
    ) async throws -> [Station]

    func getStationsByName(
        searchTerm: String,
        offset: Int,
        limit: Int
    ) async throws -> [Station]
}

