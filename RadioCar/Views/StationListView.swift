//
//  StationListView.swift
//  RadioCar
//
//  Created by Maestro Master on 24/07/2025.
//
import SwiftUI

struct StationListView: View {
    @ObservedObject var playerState = PlayerState.shared
    @ObservedObject var viewModel: StationsViewModel
    let stations: [Station]

    var body: some View {
        VStack(spacing: 0) {
            // Filter buttons
            HStack(spacing: 12) {
                FilterButton(title: "All", isSelected: viewModel.listType == .all) {
                    viewModel.setListType(.all)
                }
                FilterButton(title: "Favorites", isSelected: viewModel.listType == .favorites) {
                    viewModel.setListType(.favorites)
                }
                FilterButton(title: "Recent", isSelected: viewModel.listType == .recent) {
                    viewModel.setListType(.recent)
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
            .background(Color.black.opacity(0.5))

            // Station groups list
            if viewModel.stationGroups.isEmpty {
                // Fallback to simple station list
                List(stations) { station in
                    StationItemView(station: station)
                        .contentShape(Rectangle())
                        .listRowBackground(Color.black)
                }
                .listStyle(PlainListStyle())
                .background(Color.black.ignoresSafeArea())
            } else {
                // Show station groups
                List(viewModel.stationGroups) { group in
                    StationGroupItemView(stationGroup: group, viewModel: viewModel)
                        .contentShape(Rectangle())
                        .listRowBackground(Color.black)
                }
                .listStyle(PlainListStyle())
                .background(Color.black.ignoresSafeArea())
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .nextTrackRequested)) { _ in
            playerState.playNext()
        }
        .onReceive(NotificationCenter.default.publisher(for: .previousTrackRequested)) { _ in
            playerState.playPrevious()
        }
    }
}

struct FilterButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .fontWeight(isSelected ? .bold : .regular)
                .foregroundColor(isSelected ? .white : .gray)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(isSelected ? AppColors.grad1 : Color.gray.opacity(0.2))
                )
        }
    }
}

struct StationGroupItemView: View {
    let stationGroup: StationGroup
    @ObservedObject var viewModel: StationsViewModel
    @ObservedObject private var playerState = PlayerState.shared

    var body: some View {
        HStack(spacing: 12) {
            // Station image
            AsyncImage(url: URL(string: stationGroup.favicon)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Image(systemName: "music.note")
                    .foregroundColor(.gray)
            }
            .frame(width: 60, height: 60)
            .background(Color.gray.opacity(0.2))
            .cornerRadius(8)

            // Station info
            VStack(alignment: .leading, spacing: 4) {
                Text(stationGroup.name)
                    .font(.headline)
                    .foregroundColor(.white)
                    .lineLimit(2)

                if stationGroup.streams.count > 1 {
                    Text("\(stationGroup.streams.count) streams")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }

            Spacer()

            // Favorite button
            Button(action: {
                Task {
                    await viewModel.toggleFavorite(for: stationGroup)
                }
            }) {
                Image(systemName: stationGroup.isFavorite ? "heart.fill" : "heart")
                    .foregroundColor(stationGroup.isFavorite ? .red : .gray)
                    .font(.title3)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(.vertical, 8)
        .contentShape(Rectangle())
        .onTapGesture {
            Task {
                await viewModel.playStationGroup(stationGroup)
            }
        }
    }
}

