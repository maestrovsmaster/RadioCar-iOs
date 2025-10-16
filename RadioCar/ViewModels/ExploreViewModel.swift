//
//  ExploreViewModel.swift
//  RadioCar
//
//  Created by Maestro Master on 16/10/2025.
//

import Foundation

@MainActor
class ExploreViewModel: ObservableObject {
    @Published var searchQuery: String = ""
    @Published var selectedCountry: String = "UA"
    @Published var selectedTag: String = ""
    @Published var stationGroups: [StationGroup] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private let repository: StationRepository

    init(repository: StationRepository) {
        self.repository = repository
    }

    func search() async {
        isLoading = true
        errorMessage = nil

        do {
            // Search stations by name, country and tag
            let groups = try await repository.searchStationGroups(
                query: searchQuery,
                country: selectedCountry,
                tag: selectedTag,
                offset: 0,
                limit: 50
            )

            self.stationGroups = groups
        } catch {
            self.errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    func clearSearch() {
        searchQuery = ""
        selectedTag = ""
        stationGroups = []
    }

    func selectCountry(_ country: String) {
        selectedCountry = country
        Task {
            await search()
        }
    }

    func selectTag(_ tag: String) {
        if selectedTag == tag {
            selectedTag = ""
        } else {
            selectedTag = tag
        }
        Task {
            await search()
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

    func toggleFavorite(for stationGroup: StationGroup) async {
        guard let firstStationUuid = stationGroup.stations.first?.stationuuid else { return }

        do {
            let newFavoriteState = !stationGroup.isFavorite

            if newFavoriteState {
                try await repository.addToFavorites(stationUuid: firstStationUuid)
            } else {
                try await repository.removeFromFavorites(stationUuid: firstStationUuid)
            }

            // Update the specific group in the list
            if let index = stationGroups.firstIndex(where: { $0.id == stationGroup.id }) {
                var updatedGroup = stationGroups[index]
                updatedGroup.isFavorite = newFavoriteState
                stationGroups[index] = updatedGroup
            }
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
}
