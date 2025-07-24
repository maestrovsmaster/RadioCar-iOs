//
//  DependencyContainer.swift
//  RadioCar
//
//  Created by Maestro Master on 24/06/2025.
//

import Foundation
final class DependencyContainer: ObservableObject {
    let stationRepository: StationRepository
        // let weatherRepository: WeatherRepository
    let mediaPlayerManager: AudioPlayerManager

    init() {
        // Services
        let radioAPI = RadioAPIService()
        //let weatherAPI = WeatherAPIService()

        //Repositories
        self.stationRepository = DefaultStationRepository(remote: radioAPI)

        // Player
        self.mediaPlayerManager = AudioPlayerManager.shared

    }
}

