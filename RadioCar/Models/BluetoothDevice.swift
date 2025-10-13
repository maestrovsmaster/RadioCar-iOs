//
//  BluetoothDevice.swift
//  RadioCar
//
//  Created by Maestro Master on 13/10/2025.
//

import Foundation
import SwiftData

@available(iOS 17.0, *)
@Model
class BluetoothDevice {
    @Attribute(.unique) var identifier: String
    var name: String
    var autoPlay: Bool
    var lastConnectedDate: Date

    init(identifier: String, name: String, autoPlay: Bool = false, lastConnectedDate: Date = Date()) {
        self.identifier = identifier
        self.name = name
        self.autoPlay = autoPlay
        self.lastConnectedDate = lastConnectedDate
    }
}
