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

            // Horizontal scrollable grid
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHGrid(rows: [
                    GridItem(.fixed(120), spacing: 8),
                    GridItem(.fixed(120), spacing: 8)
                ], spacing: 8) {
                    ForEach(viewModel.stationGroups) { group in
                        StationGridTile(stationGroup: group, viewModel: viewModel)
                    }
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 8)
            }
            .background(Color.black)
        }
        .onReceive(NotificationCenter.default.publisher(for: .nextTrackRequested)) { _ in
            playerState.playNext()
        }
        .onReceive(NotificationCenter.default.publisher(for: .previousTrackRequested)) { _ in
            playerState.playPrevious()
        }
    }
}

// MARK: - Horizontal Grid Tile
struct StationGridTile: View {
    let stationGroup: StationGroup
    @ObservedObject var viewModel: StationsViewModel
    @ObservedObject private var playerState = PlayerState.shared

    var body: some View {
        VStack(spacing: 8) {
            // Station image with favorite badge
            ZStack(alignment: .topTrailing) {
                AsyncImage(url: URL(string: stationGroup.favicon)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Image(systemName: "music.note")
                        .font(.largeTitle)
                        .foregroundColor(.gray)
                }
                .frame(width: 100, height: 80)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(12)
                .clipped()

                // Favorite button overlay
                Button(action: {
                    Task {
                        await viewModel.toggleFavorite(for: stationGroup)
                    }
                }) {
                    Image(systemName: stationGroup.isFavorite ? "heart.fill" : "heart")
                        .foregroundColor(stationGroup.isFavorite ? .red : .white)
                        .font(.caption)
                        .padding(6)
                        .background(Color.black.opacity(0.6))
                        .clipShape(Circle())
                }
                .buttonStyle(PlainButtonStyle())
                .padding(4)
            }

            // Station name
            Text(stationGroup.name)
                .font(.caption)
                .foregroundColor(.white)
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .frame(width: 100, height: 30)
        }
        .frame(width: 110, height: 120)
        .contentShape(Rectangle())
        .onTapGesture {
            Task {
                await viewModel.playStationGroup(stationGroup)
            }
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

