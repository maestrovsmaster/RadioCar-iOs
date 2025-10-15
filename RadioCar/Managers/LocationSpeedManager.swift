//
//  LocationSpeedManager.swift
//  RadioCar
//
//  Created by Maestro Master on 13/10/2025.
//

import Foundation
import CoreLocation
import Combine

class LocationSpeedManager: NSObject, ObservableObject {
    static let shared = LocationSpeedManager()

    @Published var currentSpeed: Double = 0.0 // km/h
    @Published var currentLocation: String = "---"
    @Published var isAuthorized: Bool = false

    private let locationManager = CLLocationManager()
    private let geocoder = CLGeocoder()

    override private init() {
        super.init()
        setupLocationManager()
    }

    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.distanceFilter = 10 // Update every 10 meters
        locationManager.activityType = .automotiveNavigation

        // Request authorization
        checkAuthorization()
    }

    func checkAuthorization() {
        let status = locationManager.authorizationStatus

        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            isAuthorized = true
            startUpdatingLocation()
        case .denied, .restricted:
            isAuthorized = false
            print("📍 Location access denied")
        @unknown default:
            break
        }
    }

    func startUpdatingLocation() {
        guard isAuthorized else { return }
        locationManager.startUpdatingLocation()
        print("📍 Started updating location and speed")
    }

    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
        print("📍 Stopped updating location")
    }

    private func reverseGeocodeLocation(_ location: CLLocation) {
        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
            guard let self = self else { return }

            if let error = error {
                print("📍 Geocoding error: \(error.localizedDescription)")
                return
            }

            if let placemark = placemarks?.first {
                DispatchQueue.main.async {
                    // Priority: locality (city) > subLocality > administrativeArea
                    let locationName = placemark.locality
                        ?? placemark.subLocality
                        ?? placemark.administrativeArea
                        ?? "Unknown"

                    self.currentLocation = locationName
                    print("📍 Location: \(locationName)")
                }
            }
        }
    }
}

// MARK: - CLLocationManagerDelegate
extension LocationSpeedManager: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkAuthorization()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }

        // Update speed (convert m/s to km/h)
        let speedInMetersPerSecond = max(0, location.speed) // -1 means invalid
        let speedInKmh = speedInMetersPerSecond * 3.6

        DispatchQueue.main.async {
            // Only update if speed is valid
            if speedInMetersPerSecond >= 0 {
                self.currentSpeed = speedInKmh
                print("📍 Speed: \(Int(speedInKmh)) km/h")
            }
        }

        // Reverse geocode to get place name (throttle to avoid too many requests)
        if currentLocation == "---" || currentLocation == "Unknown" {
            reverseGeocodeLocation(location)
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("📍 Location error: \(error.localizedDescription)")
    }
}
