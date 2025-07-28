//
//  StationsViewModel.swift
//  RadioCar
//
//  Created by Maestro Master on 24/06/2025.
//

import Foundation

@MainActor
class StationsViewModel: ObservableObject {
    @Published var stations: [Station] = []
    @Published var errorMessage: String?

    private let repository: StationRepository

    init(repository: StationRepository) {
        self.repository = repository
    }

    func loadStations() async {
        do {
            let stations = try await repository.fetchStations(country: "UA", offset: 0, limit: 50)
            self.stations = stations
            PlayerState.shared.setStations(stations)
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
}
