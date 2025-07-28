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

 

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(container)
        }
    }
}

