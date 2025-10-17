//
//  AppConstants.swift
//  RadioCar
//
//  Created by Maestro Master on 15/10/2025.
//

import Foundation

struct AppConstants {
    // URLs
    static let privacyURL = "https://radiocartunes.wixsite.com/radiocar/privacy"
    static let aboutRadioURL = "http://api.radio-browser.info/#General"
    static let contactEmail = "radiocar.tunes@gmail.com"
    static let appStoreURL = "https://apps.apple.com/app/id6504000000" // TODO: Update with actual App Store ID

    // App Info
    static var appVersion: String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
        return "\(version) (\(build))"
    }

    static let copyrightText = "© 2025 Maestro Creations"
}

struct AppStrings {
    // Settings
    static let aboutApp = "About app"
    static let aboutAppDescription = "Radio Car: Your ideal travel companion on the road!\nThis application receives public data from open sources. If you discover any inappropriate content, please report it using the button next to the station."

    static let playbackSettings = "Playback Settings"
    static let autoplay = "Autoplay on Launch"
    static let autoplayDescription = "Automatically play the last station when app starts"

    static let privacyPolicy = "Privacy Policy"
    static let openAPI = "Open API"
    static let contactUs = "Contact Us"
    static let leaveReview = "Leave a review"
    static let appVersion = "App version"
    static let done = "Done"
    static let close = "Close"
}
