//
//  StationGroup.swift
//  RadioCar
//
//  Created by Maestro Master on 24/06/2025.
//
struct StationGroup: Identifiable, Codable {
    var id: String { name } // або якась унікальна логіка

    let name: String
    let streams: [StationStream]
    let stations: [Station] // або тільки id, якщо збережено окремо
    let favicon: String
    let isFavorite: Bool
    let countryCode: String?
}

