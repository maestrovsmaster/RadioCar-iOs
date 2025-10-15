//
//  SpeedometerCard.swift
//  RadioCar
//
//  Created by Maestro Master on 13/10/2025.
//

import SwiftUI

struct SpeedometerCard: View {
    @ObservedObject private var locationManager = LocationSpeedManager.shared
    @ObservedObject private var bluetoothManager = BluetoothManager.shared
    @StateObject private var weatherManager = WeatherManager()

    var body: some View {
        ZStack {
            // Background with gradient (dark blue to darker)
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(red: 0.2, green: 0.25, blue: 0.35),
                            Color(red: 0.15, green: 0.2, blue: 0.28)
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 5)

            // Road scene background (decorative)
            RoadSceneView()
                .opacity(0.4)

            VStack(spacing: 0) {
                // Top bar with weather, temperature, and Bluetooth
                HStack(spacing: 12) {
                    // Weather icon and temperature
                    HStack(spacing: 6) {
                        Image(systemName: weatherManager.weatherIcon)
                            .font(.callout)
                            .foregroundColor(.white)

                        Text(weatherManager.temperature)
                            .font(.callout)
                            .foregroundColor(.white)
                    }

                    Spacer()

                    // Bluetooth status
                    if bluetoothManager.isAudioDeviceConnected || bluetoothManager.currentDeviceName != nil {
                        HStack(spacing: 6) {
                            Image(systemName: "bluetooth.connected")
                                .font(.caption)
                                .foregroundColor(AppColors.blue)

                            Text(bluetoothManager.currentDeviceName ?? "Connected")
                                .font(.caption)
                                .foregroundColor(.white)
                                .lineLimit(1)
                        }
                    }

                    // Power button (decorative)
                    Button(action: {}) {
                        Image(systemName: "power")
                            .font(.callout)
                            .foregroundColor(.white)
                    }
                }
                .padding(.horizontal, 12)
                .padding(.top, 8)

                Spacer()

                // Digital speedometer (large centered)
                VStack(spacing: 2) {
                    Text(formatSpeed(locationManager.currentSpeed))
                        .font(.system(size: 42, weight: .light, design: .rounded))
                        .foregroundColor(.white)
                        .tracking(6)

                    Text("km/h")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                }
                .padding(.vertical, 8)

                Spacer()

                // Location name at bottom
                HStack(spacing: 4) {
                    Image(systemName: locationManager.isAuthorized ? "location.fill" : "location.slash")
                        .font(.caption2)
                        .foregroundColor(AppColors.blueCold)

                    Text(locationManager.currentLocation)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(AppColors.blueCold)
                }
                .padding(.bottom, 8)
            }
        }
        .frame(height: 140)
        .onAppear {
            locationManager.checkAuthorization()
            weatherManager.fetchWeather()
        }
    }

    private func formatSpeed(_ speed: Double) -> String {
        if speed < 0.5 {
            return "-- --"
        }

        let speedInt = Int(speed)
        if speedInt < 10 {
            return String(format: "0%d", speedInt)
        } else {
            return String(format: "%02d", speedInt)
        }
    }
}

// MARK: - Road Scene Background
struct RoadSceneView: View {
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Mountains silhouette
                Path { path in
                    let width = geometry.size.width
                    let height = geometry.size.height

                    path.move(to: CGPoint(x: 0, y: height * 0.6))
                    path.addLine(to: CGPoint(x: width * 0.2, y: height * 0.4))
                    path.addLine(to: CGPoint(x: width * 0.35, y: height * 0.5))
                    path.addLine(to: CGPoint(x: width * 0.5, y: height * 0.3))
                    path.addLine(to: CGPoint(x: width * 0.65, y: height * 0.45))
                    path.addLine(to: CGPoint(x: width * 0.8, y: height * 0.35))
                    path.addLine(to: CGPoint(x: width, y: height * 0.55))
                    path.addLine(to: CGPoint(x: width, y: height))
                    path.addLine(to: CGPoint(x: 0, y: height))
                    path.closeSubpath()
                }
                .fill(LinearGradient(
                    gradient: Gradient(colors: [Color.gray.opacity(0.3), Color.gray.opacity(0.1)]),
                    startPoint: .top,
                    endPoint: .bottom
                ))

                // Road perspective lines (dashed)
                Path { path in
                    let width = geometry.size.width
                    let height = geometry.size.height
                    let centerX = width / 2

                    // Left lane marker
                    path.move(to: CGPoint(x: centerX - 20, y: height * 0.8))
                    path.addLine(to: CGPoint(x: centerX - 5, y: height))

                    // Right lane marker
                    path.move(to: CGPoint(x: centerX + 20, y: height * 0.8))
                    path.addLine(to: CGPoint(x: centerX + 5, y: height))
                }
                .stroke(Color.white.opacity(0.3), style: StrokeStyle(lineWidth: 2, dash: [10, 5]))
            }
        }
    }
}

// MARK: - Weather Manager
class WeatherManager: ObservableObject {
    @Published var temperature: String = "- -°C"
    @Published var weatherIcon: String = "cloud.fill"

    func fetchWeather() {
        // Placeholder - можна додати API запит до OpenWeather
        // Поки що показуємо статичні дані
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.temperature = "18°C"
            self.weatherIcon = "cloud.sun.fill"
        }
    }
}

#Preview {
    SpeedometerCard()
        .padding()
        .background(Color.black)
}
