//
//  SettingsManager.swift
//  RadioCar
//
//  Created by Maestro Master on 17/10/2025.
//

import Foundation
import Combine

/// Manages app settings using UserDefaults
final class SettingsManager: ObservableObject {
    static let shared = SettingsManager()

    private let defaults = UserDefaults.standard

    // MARK: - Keys

    private enum Keys {
        static let autoplay = "settings.autoplay"
    }

    // MARK: - Published Settings

    /// Whether to automatically play the last station on app launch
    @Published var autoplay: Bool {
        didSet {
            defaults.set(autoplay, forKey: Keys.autoplay)
        }
    }

    // MARK: - Initialization

    private init() {
        // Load saved settings or use defaults
        self.autoplay = defaults.bool(forKey: Keys.autoplay)
    }
}
