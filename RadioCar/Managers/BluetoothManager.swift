//
//  BluetoothManager.swift
//  RadioCar
//
//  Created by Maestro Master on 13/10/2025.
//

import Foundation
import ExternalAccessory
import Combine
import SwiftData
import AVFoundation

class BluetoothManager: NSObject, ObservableObject {
    static let shared = BluetoothManager()

    @Published var connectedDevices: [EAAccessory] = []
    @Published var isBluetoothEnabled: Bool = true
    @Published var currentDeviceName: String?
    @Published var isAudioDeviceConnected: Bool = false

    private var cancellables = Set<AnyCancellable>()
    private var modelContext: Any?

    override private init() {
        super.init()
        setupNotifications()
        checkConnectedDevices()
        checkAudioRoute()
    }

    @available(iOS 17.0, *)
    func setModelContext(_ context: ModelContext) {
        self.modelContext = context as Any
    }

    private func setupNotifications() {
        // Listen for accessory connections (MFi devices)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(accessoryDidConnect),
            name: .EAAccessoryDidConnect,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(accessoryDidDisconnect),
            name: .EAAccessoryDidDisconnect,
            object: nil
        )

        // Register for external accessory notifications
        EAAccessoryManager.shared().registerForLocalNotifications()

        // Listen for audio route changes (standard Bluetooth audio)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(audioRouteChanged),
            name: AVAudioSession.routeChangeNotification,
            object: nil
        )
    }

    @objc private func accessoryDidConnect(notification: Notification) {
        guard let accessory = notification.userInfo?[EAAccessoryKey] as? EAAccessory else {
            return
        }

        print("🔵 Bluetooth device connected: \(accessory.name)")

        DispatchQueue.main.async {
            self.connectedDevices = EAAccessoryManager.shared().connectedAccessories
            self.currentDeviceName = accessory.name

            // Save device to database
            if #available(iOS 17.0, *) {
                Task { @MainActor in
                    await self.saveConnectedDevice(accessory)

                    // Check if auto-play is enabled for this device
                    if await self.shouldAutoPlay(for: accessory.name) {
                        print("🔵 Auto-play enabled for \(accessory.name)")
                        self.startAutoPlay()
                    }
                }
            }
        }
    }

    @objc private func accessoryDidDisconnect(notification: Notification) {
        guard let accessory = notification.userInfo?[EAAccessoryKey] as? EAAccessory else {
            return
        }

        print("🔵 Bluetooth device disconnected: \(accessory.name)")

        DispatchQueue.main.async {
            self.connectedDevices = EAAccessoryManager.shared().connectedAccessories
            if self.currentDeviceName == accessory.name {
                self.currentDeviceName = nil
            }
        }
    }

    private func checkConnectedDevices() {
        connectedDevices = EAAccessoryManager.shared().connectedAccessories
        if let first = connectedDevices.first {
            currentDeviceName = first.name
        }
    }

    @objc private func audioRouteChanged(notification: Notification) {
        checkAudioRoute()
    }

    private func checkAudioRoute() {
        let audioSession = AVAudioSession.sharedInstance()
        let currentRoute = audioSession.currentRoute

        // Check if any output is Bluetooth
        let hasBluetoothOutput = currentRoute.outputs.contains { output in
            let type = output.portType
            return type == .bluetoothA2DP || type == .bluetoothLE || type == .bluetoothHFP
        }

        DispatchQueue.main.async {
            self.isAudioDeviceConnected = hasBluetoothOutput

            if hasBluetoothOutput {
                // Get device name from first Bluetooth output
                if let bluetoothOutput = currentRoute.outputs.first(where: { output in
                    let type = output.portType
                    return type == .bluetoothA2DP || type == .bluetoothLE || type == .bluetoothHFP
                }) {
                    let deviceName = bluetoothOutput.portName
                    print("🔵 Bluetooth audio device connected: \(deviceName)")
                    self.currentDeviceName = deviceName
                }
            } else {
                print("🔵 No Bluetooth audio device connected")
                // Only clear if no EAAccessory connected
                if self.connectedDevices.isEmpty {
                    self.currentDeviceName = nil
                }
            }
        }
    }

    @available(iOS 17.0, *)
    @MainActor
    private func saveConnectedDevice(_ accessory: EAAccessory) async {
        guard let context = modelContext as? ModelContext else { return }

        // Check if device already exists
        let serialNumber = accessory.serialNumber
        let descriptor = FetchDescriptor<BluetoothDevice>(
            predicate: #Predicate { $0.identifier == serialNumber }
        )

        do {
            let existing = try context.fetch(descriptor)
            if existing.isEmpty {
                // Create new device
                let device = BluetoothDevice(
                    identifier: accessory.serialNumber,
                    name: accessory.name,
                    autoPlay: false
                )
                context.insert(device)
                try context.save()
                print("🔵 Saved new Bluetooth device: \(accessory.name)")
            } else {
                // Update last connected date
                if let device = existing.first {
                    device.lastConnectedDate = Date()
                    try context.save()
                }
            }
        } catch {
            print("❌ Failed to save Bluetooth device: \(error)")
        }
    }

    @available(iOS 17.0, *)
    @MainActor
    private func shouldAutoPlay(for deviceName: String) async -> Bool {
        guard let context = modelContext as? ModelContext else { return false }

        let descriptor = FetchDescriptor<BluetoothDevice>(
            predicate: #Predicate { $0.name == deviceName }
        )

        do {
            let devices = try context.fetch(descriptor)
            return devices.first?.autoPlay ?? false
        } catch {
            print("❌ Failed to check auto-play: \(error)")
            return false
        }
    }

    private func startAutoPlay() {
        // Start playing last station
        let playerState = PlayerState.shared
        if let currentStation = playerState.currentStation {
            playerState.playStation(currentStation)
        } else if let firstGroup = playerState.stationGroups.first {
            playerState.playStationGroup(firstGroup)
        }
    }

    @available(iOS 17.0, *)
    @MainActor
    func getStoredDevices() async -> [BluetoothDevice] {
        guard let context = modelContext as? ModelContext else { return [] }

        let descriptor = FetchDescriptor<BluetoothDevice>(
            sortBy: [SortDescriptor(\.lastConnectedDate, order: .reverse)]
        )

        do {
            return try context.fetch(descriptor)
        } catch {
            print("❌ Failed to fetch Bluetooth devices: \(error)")
            return []
        }
    }

    @available(iOS 17.0, *)
    @MainActor
    func toggleAutoPlay(for device: BluetoothDevice) async {
        guard let context = modelContext as? ModelContext else { return }

        device.autoPlay.toggle()

        do {
            try context.save()
            print("🔵 Auto-play toggled for \(device.name): \(device.autoPlay)")
        } catch {
            print("❌ Failed to toggle auto-play: \(error)")
        }
    }

    @available(iOS 17.0, *)
    @MainActor
    func deleteDevice(_ device: BluetoothDevice) async {
        guard let context = modelContext as? ModelContext else { return }

        context.delete(device)

        do {
            try context.save()
            print("🔵 Deleted Bluetooth device: \(device.name)")
        } catch {
            print("❌ Failed to delete device: \(error)")
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
