//
//  StationStream.swift
//  RadioCar
//
//  Created by Maestro Master on 24/06/2025.
//

import Foundation
struct StationStream: Identifiable, Codable {
    var id: String { stationUuid }

    let stationUuid: String
    let url: URL
    let bitrate: BitrateOption
}

