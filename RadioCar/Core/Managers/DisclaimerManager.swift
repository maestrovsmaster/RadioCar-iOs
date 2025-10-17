//
//  DisclaimerManager.swift
//  RadioCar
//
//  Created by Maestro Master on 17/10/2025.
//

import Foundation

/// Manages the disclaimer acceptance state
final class DisclaimerManager {
    static let shared = DisclaimerManager()

    private let defaults = UserDefaults.standard

    // MARK: - Keys

    private enum Keys {
        static let disclaimerShown = "disclaimer.shown"
    }

    // MARK: - Public Methods

    /// Check if disclaimer has been accepted
    var hasAcceptedDisclaimer: Bool {
        return defaults.bool(forKey: Keys.disclaimerShown)
    }

    /// Mark disclaimer as accepted
    func acceptDisclaimer() {
        defaults.set(true, forKey: Keys.disclaimerShown)
    }

    // MARK: - Initialization

    private init() {}
}
