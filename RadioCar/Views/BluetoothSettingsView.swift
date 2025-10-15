//
//  BluetoothSettingsView.swift
//  RadioCar
//
//  Created by Maestro Master on 13/10/2025.
//

import SwiftUI
import SwiftData

@available(iOS 17.0, *)
struct BluetoothSettingsView: View {
    @ObservedObject var bluetoothManager = BluetoothManager.shared
    @Environment(\.modelContext) private var modelContext
    @State private var devices: [BluetoothDevice] = []
    @State private var isLoading = true

    var body: some View {
        NavigationView {
            List {
                // Current connection status
                Section("Connection Status") {
                    HStack {
                        Image(systemName: bluetoothManager.currentDeviceName != nil ? "bluetooth.connected" : "bluetooth")
                            .foregroundColor(bluetoothManager.currentDeviceName != nil ? AppColors.blue : AppColors.gray)
                            .font(.title2)

                        VStack(alignment: .leading, spacing: 4) {
                            Text("Bluetooth Status")
                                .font(.headline)

                            if let deviceName = bluetoothManager.currentDeviceName {
                                Text("Connected: \(deviceName)")
                                    .font(.subheadline)
                                    .foregroundColor(AppColors.green)
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

                // Saved devices
                Section {
                    if isLoading {
                        HStack {
                            Spacer()
                            ProgressView()
                            Spacer()
                        }
                    } else if devices.isEmpty {
                        Text("No saved Bluetooth devices")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    } else {
                        ForEach(devices) { device in
                            BluetoothDeviceRow(device: device, bluetoothManager: bluetoothManager)
                        }
                        .onDelete(perform: deleteDevices)
                    }
                } header: {
                    Text("Saved Devices")
                } footer: {
                    Text("Enable auto-play to start playing automatically when connecting to a device")
                        .font(.caption)
                }

                // Info section
                Section("How it works") {
                    Label("Connect your Bluetooth device", systemImage: "1.circle.fill")
                    Label("Device will be saved automatically", systemImage: "2.circle.fill")
                    Label("Toggle auto-play for your device", systemImage: "3.circle.fill")
                    Label("Radio starts playing when connected", systemImage: "4.circle.fill")
                }
                .font(.subheadline)
            }
            .navigationTitle("Bluetooth Settings")
            .navigationBarTitleDisplayMode(.inline)
            .task {
                await loadDevices()
            }
            .refreshable {
                await loadDevices()
            }
        }
    }

    private func loadDevices() async {
        isLoading = true
        devices = await bluetoothManager.getStoredDevices()
        isLoading = false
    }

    private func deleteDevices(at offsets: IndexSet) {
        Task {
            for index in offsets {
                await bluetoothManager.deleteDevice(devices[index])
            }
            await loadDevices()
        }
    }
}

@available(iOS 17.0, *)
struct BluetoothDeviceRow: View {
    let device: BluetoothDevice
    @ObservedObject var bluetoothManager: BluetoothManager

    var body: some View {
        HStack(spacing: 12) {
            // Device icon
            Image(systemName: "speaker.wave.2.circle.fill")
                .font(.title2)
                .foregroundColor(AppColors.blue)

            // Device info
            VStack(alignment: .leading, spacing: 4) {
                Text(device.name)
                    .font(.headline)

                HStack(spacing: 8) {
                    Text(device.identifier)
                        .font(.caption)
                        .foregroundColor(.secondary)

                    if bluetoothManager.currentDeviceName == device.name {
                        Text("• Connected")
                            .font(.caption)
                            .foregroundColor(AppColors.green)
                    }
                }

                Text("Last connected: \(device.lastConnectedDate, formatter: dateFormatter)")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }

            Spacer()

            // Auto-play toggle
            VStack(alignment: .trailing, spacing: 4) {
                Text("Auto-play")
                    .font(.caption)
                    .foregroundColor(.secondary)

                Toggle("", isOn: Binding(
                    get: { device.autoPlay },
                    set: { _ in
                        Task {
                            await bluetoothManager.toggleAutoPlay(for: device)
                        }
                    }
                ))
                .labelsHidden()
            }
        }
        .padding(.vertical, 4)
    }

    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }
}

@available(iOS 17.0, *)
#Preview {
    BluetoothSettingsView()
        .modelContainer(for: [BluetoothDevice.self], inMemory: true)
}
