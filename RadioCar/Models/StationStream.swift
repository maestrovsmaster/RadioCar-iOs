//
//  StationStream.swift
//  RadioCar
//
//  Created by Maestro Master on 24/06/2025.
//

import Foundation

struct StationStream: Identifiable, Codable, Hashable {
    var id: String { stationUuid }

    let stationUuid: String
    let url: String
    let bitrate: Int

    var urlResolved: URL? {
        URL(string: url)
    }

    var bitrateOption: BitrateOption {
        BitrateOption.from(bitrate)
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(stationUuid)
    }

    static func == (lhs: StationStream, rhs: StationStream) -> Bool {
        lhs.stationUuid == rhs.stationUuid
    }
}

