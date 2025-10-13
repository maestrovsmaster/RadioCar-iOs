//
//  RecentStation.swift
//  RadioCar
//
//  Created by Maestro Master on 24/06/2025.
//
import Foundation
import SwiftData

@available(iOS 17.0, *)
@Model
class RecentStation {
    @Attribute(.unique) var stationuuid: String
    var lastPlayedTime: Date

    init(stationuuid: String, lastPlayedTime: Date = Date()) {
        self.stationuuid = stationuuid
        self.lastPlayedTime = lastPlayedTime
    }
}

