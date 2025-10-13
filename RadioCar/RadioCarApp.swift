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

    @available(iOS 17.0, *)
    var modelContainer: ModelContainer {
        let schema = Schema([
            FavoriteStation.self,
            RecentStation.self
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
                    .modelContainer(modelContainer)
            } else {
                ContentView()
                    .environmentObject(container)
            }
        }
    }
}

