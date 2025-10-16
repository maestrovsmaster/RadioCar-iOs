//
//  ExploreView.swift
//  RadioCar
//
//  Created by Maestro Master on 16/10/2025.
//

import SwiftUI

struct ExploreView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel: ExploreViewModel
    @ObservedObject private var playerState = PlayerState.shared

    // Available countries for filtering
    let countries = ["UA", "US", "GB", "DE", "FR", "PL", "IT", "ES"]

    // Popular tags for radio stations
    let availableTags = ["pop", "rock", "jazz", "classical", "electronic", "hip hop", "country", "news", "talk", "sports"]

    init(repository: StationRepository) {
        _viewModel = StateObject(wrappedValue: ExploreViewModel(repository: repository))
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Search bar with back button
                HStack(spacing: 12) {
                    // Back button
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "arrow.left")
                            .font(.title3)
                            .foregroundColor(.white)
                            .frame(width: 44, height: 44)
                    }

                    // Search field
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)

                        TextField("Search stations...", text: $viewModel.searchQuery)
                            .foregroundColor(.white)
                            .textFieldStyle(PlainTextFieldStyle())
                            .onChange(of: viewModel.searchQuery) { _ in
                                Task {
                                    await viewModel.search()
                                }
                            }

                        if !viewModel.searchQuery.isEmpty {
                            Button(action: {
                                viewModel.clearSearch()
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                }
                .padding(.horizontal)
                .padding(.top, 16)
                .padding(.bottom, 8)

                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        // Country filter section
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Country")
                                .font(.headline)
                                .foregroundColor(.white)

                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 12) {
                                    ForEach(countries, id: \.self) { country in
                                        Button(action: {
                                            viewModel.selectCountry(country)
                                        }) {
                                            Text(country)
                                                .font(.subheadline)
                                                .fontWeight(viewModel.selectedCountry == country ? .bold : .regular)
                                                .foregroundColor(viewModel.selectedCountry == country ? .white : .gray)
                                                .padding(.horizontal, 16)
                                                .padding(.vertical, 8)
                                                .background(
                                                    RoundedRectangle(cornerRadius: 20)
                                                        .fill(viewModel.selectedCountry == country ? AppColors.grad1 : Color.gray.opacity(0.2))
                                                )
                                        }
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)

                        // Tags filter section
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Tags")
                                .font(.headline)
                                .foregroundColor(.white)

                            // Tags grid
                            LazyVGrid(columns: [
                                GridItem(.adaptive(minimum: 80), spacing: 12)
                            ], spacing: 12) {
                                ForEach(availableTags, id: \.self) { tag in
                                    Button(action: {
                                        viewModel.selectTag(tag)
                                    }) {
                                        Text(tag.capitalized)
                                            .font(.subheadline)
                                            .fontWeight(viewModel.selectedTag == tag ? .bold : .regular)
                                            .foregroundColor(viewModel.selectedTag == tag ? .white : .gray)
                                            .padding(.horizontal, 16)
                                            .padding(.vertical, 8)
                                            .background(
                                                RoundedRectangle(cornerRadius: 20)
                                                    .fill(viewModel.selectedTag == tag ? AppColors.grad1 : Color.gray.opacity(0.2))
                                            )
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }

                        // Results section
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Results (\(viewModel.stationGroups.count))")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding(.horizontal)

                            if viewModel.isLoading {
                                HStack {
                                    Spacer()
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                        .scaleEffect(1.5)
                                        .padding(40)
                                    Spacer()
                                }
                            } else if viewModel.stationGroups.isEmpty {
                                Text(viewModel.searchQuery.isEmpty && viewModel.selectedTag.isEmpty ?
                                     "Enter search term or select filters" :
                                     "No stations found")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                    .frame(maxWidth: .infinity, minHeight: 200)
                                    .background(Color.gray.opacity(0.1))
                                    .cornerRadius(10)
                                    .padding(.horizontal)
                            } else {
                                LazyVGrid(columns: [
                                    GridItem(.flexible(), spacing: 8),
                                    GridItem(.flexible(), spacing: 8)
                                ], spacing: 12) {
                                    ForEach(viewModel.stationGroups) { group in
                                        ExploreStationCard(
                                            stationGroup: group,
                                            viewModel: viewModel
                                        )
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                        .padding(.top, 20)
                    }
                    .padding(.vertical)
                }
            }
            .background(Color.black)
            .navigationBarHidden(true)
        }
    }
}

// MARK: - Explore Station Card
struct ExploreStationCard: View {
    let stationGroup: StationGroup
    @ObservedObject var viewModel: ExploreViewModel
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
                .frame(width: 160, height: 120)
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
                .frame(width: 160, height: 30)
        }
        .frame(width: 170, height: 160)
        .contentShape(Rectangle())
        .onTapGesture {
            Task {
                await viewModel.playStationGroup(stationGroup)
            }
        }
    }
}

#Preview {
    let container = DependencyContainer()
    return ExploreView(repository: container.stationRepository)
}
