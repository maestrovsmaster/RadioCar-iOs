//
//  StationGroup.swift
//  RadioCar
//
//  Created by Maestro Master on 24/06/2025.
//

import Foundation

struct StationGroup: Identifiable, Codable, Hashable {
    var id: String { name }

    let name: String
    let streams: [StationStream]
    let stations: [Station]
    let favicon: String
    var isFavorite: Bool
    let countryCode: String?

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: StationGroup, rhs: StationGroup) -> Bool {
        lhs.id == rhs.id
    }
}

