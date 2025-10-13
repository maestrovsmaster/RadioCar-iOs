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
            if #available(iOS 17.0, *) {
                ContentView()
                    .environmentObject(container)
                    .environmentObject(bluetoothManager)
                    .modelContainer(modelContainer)
                    .onAppear {
                        // Initialize BluetoothManager with modelContext
                        if let context = try? ModelContext(modelContainer) {
                            bluetoothManager.setModelContext(context)
                        }
                    }
            } else {
                ContentView()
                    .environmentObject(container)
                    .environmentObject(bluetoothManager)
            }
        }
    }
}

