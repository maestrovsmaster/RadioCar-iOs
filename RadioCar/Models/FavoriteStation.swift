//
//  FavoriteStation.swift
//  RadioCar
//
//  Created by Maestro Master on 24/06/2025.
//

import Foundation
import SwiftData

@available(iOS 17.0, *)
@Model
class FavoriteStation {
    @Attribute(.unique) var stationuuid: String
    var addedTime: Date

    init(stationuuid: String, addedTime: Date = Date()) {
        self.stationuuid = stationuuid
        self.addedTime = addedTime
    }
}
