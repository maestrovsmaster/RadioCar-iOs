//
//  RadioCarApp.swift
//  RadioCar
//
//  Created by Maestro Master on 24/06/2025.
//

import SwiftUI
import SwiftData

@main
struct RadioCarApp: App {
    @StateObject private var container = DependencyContainer()
    @StateObject private var bluetoothManager = BluetoothManager.shared
    @StateObject private var playerState = PlayerState.shared
    @StateObject private var settings = SettingsManager.shared
    @State private var showDisclaimer = !DisclaimerManager.shared.hasAcceptedDisclaimer
    @State private var disclaimerAccepted = DisclaimerManager.shared.hasAcceptedDisclaimer

    init() {
        // Load last station on app init (runs once)
        PlayerState.shared.loadLastStation(autoplay: SettingsManager.shared.autoplay)
    }

    @available(iOS 17.0, *)
    var modelContainer: ModelContainer {
        let schema = Schema([
            FavoriteStation.self,
            RecentStation.self,
            BluetoothDevice.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            if disclaimerAccepted {
                if #available(iOS 17.0, *) {
                    ContentView()
                        .environmentObject(container)
                        .environmentObject(bluetoothManager)
                        .modelContainer(modelContainer)
                        .onAppear {
                            // Initialize BluetoothManager with modelContext
                            let context = modelContainer.mainContext
                            bluetoothManager.setModelContext(context)
                        }
                } else {
                    ContentView()
                        .environmentObject(container)
                        .environmentObject(bluetoothManager)
                }
            } else {
                // Show disclaimer screen
                DisclaimerView(onAccept: {
                    DisclaimerManager.shared.acceptDisclaimer()
                    disclaimerAccepted = true
                    showDisclaimer = false
                })
            }
        }
    }
}

