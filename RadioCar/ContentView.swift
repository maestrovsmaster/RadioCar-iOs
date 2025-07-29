//
//  ContentView.swift
//  RadioCar
//
//  Created by Maestro Master on 24/06/2025.
//

import SwiftUI
import SwiftData


struct ContentView: View {
    @StateObject private var viewModel: StationsViewModel
    @ObservedObject private var playerState = PlayerState.shared

    init() {
        let radioAPI = RadioAPIService()
        let repository = DefaultStationRepository(remote: radioAPI)
        _viewModel = StateObject(wrappedValue: StationsViewModel(repository: repository))
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                MediumPlayerView()
                    .frame(maxWidth: .infinity)
                    .frame(height: UIScreen.main.bounds.height * 0.45) // 45% висоти екрану, можна коригувати
                   

                StationListView(stations: viewModel.stations)
                    .frame(maxWidth: .infinity)
                    .frame(height: UIScreen.main.bounds.height * 0.55) // решта висоти
            }.background(Color.black) 
            //.navigationTitle("Radio Stations")
            .task {
                await viewModel.loadStations()
            }
            .alert("Error", isPresented: Binding(get: {
                viewModel.errorMessage != nil
            }, set: { newValue in
                if !newValue { viewModel.errorMessage = nil }
            }), actions: {}) {
                Text(viewModel.errorMessage ?? "Unknown error")
            }
        }
    }
}

