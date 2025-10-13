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
    @Published var stationGroups: [StationGroup] = []
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    @Published var listType: ListType = .all
    @Published var currentCountry: String = "UA"

    private let repository: StationRepository

    init(repository: StationRepository) {
        self.repository = repository
    }

    func loadStations() async {
        isLoading = true
        errorMessage = nil

        do {
            let stations = try await repository.fetchStations(country: currentCountry, offset: 0, limit: 100)
            self.stations = stations
            PlayerState.shared.setStations(stations)

            // Load station groups based on list type
            await loadStationGroups()
        } catch {
            self.errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    func loadStationGroups() async {
        do {
            let groups: [StationGroup]

            switch listType {
            case .all:
                groups = try await repository.fetchStationGroups(country: currentCountry, offset: 0, limit: 100)
            case .favorites:
                groups = try await repository.getFavoriteStationGroups()
            case .recent:
                groups = try await repository.getRecentStationGroups()
            }

            self.stationGroups = groups
            PlayerState.shared.setStationGroups(groups)
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }

    func setListType(_ type: ListType) {
        listType = type
        Task {
            await loadStationGroups()
        }
    }

    func toggleFavorite(for stationGroup: StationGroup) async {
        do {
            let firstStationUuid = stationGroup.stations.first?.stationuuid ?? ""

            if stationGroup.isFavorite {
                try await repository.removeFromFavorites(stationUuid: firstStationUuid)
            } else {
                try await repository.addToFavorites(stationUuid: firstStationUuid)
            }

            // Reload groups
            await loadStationGroups()
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }

    func playStationGroup(_ group: StationGroup) async {
        PlayerState.shared.playStationGroup(group)

        // Add to recent
        if let firstStationUuid = group.stations.first?.stationuuid {
            do {
                try await repository.addToRecent(stationUuid: firstStationUuid)
            } catch {
                print("Failed to add to recent: \(error)")
            }
        }
    }
}
