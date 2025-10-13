//
//  BluetoothConnectionView.swift
//  RadioCar
//
//  Created by Maestro Master on 13/10/2025.
//

import SwiftUI

/// Simplified Bluetooth view for iOS 15-16 (without SwiftData)
struct BluetoothConnectionView: View {
    @ObservedObject var bluetoothManager = BluetoothManager.shared

    var body: some View {
        NavigationView {
            List {
                // Current connection status
                Section("Connection Status") {
                    HStack {
                        Image(systemName: (bluetoothManager.currentDeviceName != nil || bluetoothManager.isAudioDeviceConnected) ? "bluetooth.connected" : "bluetooth")
                            .foregroundColor((bluetoothManager.currentDeviceName != nil || bluetoothManager.isAudioDeviceConnected) ? .blue : .gray)
                            .font(.title2)

                        VStack(alignment: .leading, spacing: 4) {
                            Text("Bluetooth Status")
                                .font(.headline)

                            if let deviceName = bluetoothManager.currentDeviceName {
                                Text("Connected: \(deviceName)")
                                    .font(.subheadline)
                                    .foregroundColor(.green)
                            } else if bluetoothManager.isAudioDeviceConnected {
                                Text("Bluetooth Audio Connected")
                                    .font(.subheadline)
                                    .foregroundColor(.green)
                            } else {
                                Text("Not connected")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }

                        Spacer()
                    }
                    .padding(.vertical, 8)
                }

                // Connected devices list
                if !bluetoothManager.connectedDevices.isEmpty || bluetoothManager.isAudioDeviceConnected {
                    Section("Connected Devices") {
                        // MFi accessories
                        ForEach(bluetoothManager.connectedDevices, id: \.serialNumber) { accessory in
                            HStack(spacing: 12) {
                                Image(systemName: "speaker.wave.2.circle.fill")
                                    .font(.title2)
                                    .foregroundColor(.blue)

                                VStack(alignment: .leading, spacing: 4) {
                                    Text(accessory.name)
                                        .font(.headline)

                                    Text(accessory.serialNumber)
                                        .font(.caption)
                                        .foregroundColor(.secondary)

                                    Text("MFi Accessory • Connected")
                                        .font(.caption)
                                        .foregroundColor(.green)
                                }

                                Spacer()
                            }
                            .padding(.vertical, 4)
                        }

                        // Bluetooth Audio devices
                        if bluetoothManager.isAudioDeviceConnected && bluetoothManager.connectedDevices.isEmpty {
                            HStack(spacing: 12) {
                                Image(systemName: getBluetoothIcon(for: bluetoothManager.currentDeviceName))
                                    .font(.title2)
                                    .foregroundColor(.blue)

                                VStack(alignment: .leading, spacing: 4) {
                                    Text(bluetoothManager.currentDeviceName ?? "Bluetooth Audio")
                                        .font(.headline)

                                    Text(getDeviceType(for: bluetoothManager.currentDeviceName))
                                        .font(.caption)
                                        .foregroundColor(.secondary)

                                    Text("Connected")
                                        .font(.caption)
                                        .foregroundColor(.green)
                                }

                                Spacer()
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }

                // Info section
                Section("About Auto-Play") {
                    VStack(alignment: .leading, spacing: 12) {
                        Label {
                            Text("Auto-play feature requires iOS 17+")
                                .font(.subheadline)
                        } icon: {
                            Image(systemName: "info.circle")
                                .foregroundColor(.blue)
                        }

                        Text("Your device is running iOS \(UIDevice.current.systemVersion)")
                            .font(.caption)
                            .foregroundColor(.secondary)

                        Divider()

                        Text("Current features available:")
                            .font(.caption)
                            .fontWeight(.semibold)

                        VStack(alignment: .leading, spacing: 6) {
                            Label("View connected Bluetooth devices", systemImage: "checkmark.circle.fill")
                                .font(.caption)
                                .foregroundColor(.green)

                            Label("See connection status", systemImage: "checkmark.circle.fill")
                                .font(.caption)
                                .foregroundColor(.green)

                            Label("Manual playback control", systemImage: "checkmark.circle.fill")
                                .font(.caption)
                                .foregroundColor(.green)
                        }

                        Divider()

                        Text("iOS 17+ features:")
                            .font(.caption)
                            .fontWeight(.semibold)

                        VStack(alignment: .leading, spacing: 6) {
                            Label("Auto-play on connection", systemImage: "plus.circle")
                                .font(.caption)
                                .foregroundColor(.orange)

                            Label("Save device preferences", systemImage: "plus.circle")
                                .font(.caption)
                                .foregroundColor(.orange)

                            Label("Connection history", systemImage: "plus.circle")
                                .font(.caption)
                                .foregroundColor(.orange)
                        }
                    }
                    .padding(.vertical, 4)
                }

                // How to use
                Section("How to Use") {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("1. Connect your Bluetooth device")
                        Text("2. Open RadioCar")
                        Text("3. Select a station")
                        Text("4. Press play")
                    }
                    .font(.subheadline)
                }
            }
            .navigationTitle("Bluetooth")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    // Helper functions to determine device type
    private func getBluetoothIcon(for deviceName: String?) -> String {
        guard let name = deviceName?.lowercased() else {
            return "speaker.wave.2.circle.fill"
        }

        // Car audio systems
        if name.contains("car") || name.contains("auto") || name.contains("vehicle") {
            return "car.fill"
        }

        // AirPods
        if name.contains("airpods") {
            if name.contains("pro") {
                return "airpodspro"
            } else if name.contains("max") {
                return "airpodsmax"
            }
            return "airpods"
        }

        // Beats headphones
        if name.contains("beats") || name.contains("powerbeats") || name.contains("studio") {
            return "beats.headphones"
        }

        // Generic headphones
        if name.contains("headphone") || name.contains("headset") {
            return "headphones"
        }

        // Speakers
        if name.contains("speaker") || name.contains("boom") || name.contains("soundbar") {
            return "hifispeaker.fill"
        }

        // HomePod
        if name.contains("homepod") {
            return "homepod.fill"
        }

        // Default for unknown devices
        return "airpodspro"
    }

    private func getDeviceType(for deviceName: String?) -> String {
        guard let name = deviceName?.lowercased() else {
            return "Bluetooth Audio (A2DP)"
        }

        if name.contains("car") || name.contains("auto") || name.contains("vehicle") {
            return "Car Audio System (A2DP)"
        }

        if name.contains("airpods") {
            return "AirPods"
        }

        if name.contains("beats") {
            return "Beats Headphones"
        }

        if name.contains("headphone") || name.contains("headset") {
            return "Bluetooth Headphones"
        }

        if name.contains("speaker") {
            return "Bluetooth Speaker"
        }

        if name.contains("homepod") {
            return "HomePod"
        }

        return "Bluetooth Audio (A2DP)"
    }
}

#Preview {
    BluetoothConnectionView()
}
