//
//  ContentView.swift
//  RadioCar
//
//  Created by Maestro Master on 24/06/2025.
//

import SwiftUI
import SwiftData

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel: StationsViewModel
    @ObservedObject private var playerState = PlayerState.shared
    @State private var showBluetoothSettings = false

    init() {
        let radioAPI = RadioAPIService()
        let repository = DefaultStationRepository(remote: radioAPI)
        _viewModel = StateObject(wrappedValue: StationsViewModel(repository: repository))
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 8) {

                // 1️⃣ Speedometer Card - Fixed height
                SpeedometerCard()
                    .frame(height: 180)
                    .padding(.horizontal, 8)

                // 2️⃣ Controls + Player Row - Fixed height
                HStack(spacing: 8) {
                    ControlsWidget(onSettingsTap: {
                        showBluetoothSettings = true
                    })
                    .frame(width: 80)

                    MediumPlayerView()
                        .frame(maxWidth: .infinity)
                }
                .frame(height: 260)
                .padding(.horizontal, 4)

                // 3️⃣ Station List - takes remaining space
                StationListView(playerState: playerState, viewModel: viewModel, stations: viewModel.stations)
                    .frame(maxWidth: .infinity)
                    .frame(maxHeight: .infinity)
            }
            .background(Color.black)
            .navigationBarHidden(true)
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
        .navigationViewStyle(.stack)
        .sheet(isPresented: $showBluetoothSettings) {
            if #available(iOS 17.0, *) {
                BluetoothSettingsView()
            } else {
                BluetoothConnectionView()
            }
        }
    }
}

// ✅ Прев’ю
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
                .preferredColorScheme(.light)
            ContentView()
                .preferredColorScheme(.dark)
        }
    }
}
