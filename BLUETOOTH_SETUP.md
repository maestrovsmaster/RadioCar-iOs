# Bluetooth Auto-Play Setup

## Feature Overview

RadioCar now supports Bluetooth device detection and connection monitoring for your car audio system.

### Bluetooth Device Types Supported

1. **Standard Bluetooth Audio (A2DP)** - Most common:
   - Car audio systems
   - Bluetooth speakers
   - Headphones and earbuds
   - Works on all iOS versions (15.8+)
   - Detection via AVAudioSession

2. **MFi Certified Accessories** - Less common:
   - Apple-certified accessories
   - Requires special hardware certification
   - Detection via ExternalAccessory framework

## How It Works

### 1. First Connection
- Connect your iPhone to your car's Bluetooth system
- RadioCar will automatically save this device to the database
- Auto-play is disabled by default

### 2. Configuring Auto-Play
1. Open the RadioCar app
2. Tap the **Settings button** (gear icon on the left side of the screen)
3. You'll see the "Bluetooth Settings" screen with:
   - **Connection Status** - current connection state
   - **Saved Devices** - list of saved devices
   - **How it works** - instructions

4. In the "Saved Devices" section, find your car device
5. Enable the **Auto-play** toggle for the desired device

### 3. Automatic Playback
After enabling auto-play:
- When connecting to a saved device, RadioCar will automatically start playback
- It will play the last station you were listening to
- Or the first station from your list if the last station is unavailable

## Important Details

### Where is the Settings Button?
- On the left side of the main screen
- Below the Phone (green) and Maps (blue) buttons
- Gray button with gear icon

### Managing Devices
- **Delete**: Swipe left on a device → Delete
- **Refresh list**: Pull down the list (pull-to-refresh)

### System Requirements
- **iOS 15.8+** - Basic Bluetooth detection and connection status
- **iOS 17.0+** - Full features including auto-play and device storage
- ExternalAccessory framework for Bluetooth detection
- Permissions: `NSBluetoothAlwaysUsageDescription` (already configured)

### Features by iOS Version

**iOS 15-16 (BluetoothConnectionView):**
- ✅ View connected Bluetooth devices
- ✅ See connection status in real-time
- ✅ Manual playback control
- ❌ Auto-play on connection (requires iOS 17+)
- ❌ Save device preferences (requires iOS 17+)
- ❌ Connection history (requires iOS 17+)

**iOS 17+ (BluetoothSettingsView):**
- ✅ All iOS 15-16 features
- ✅ Auto-play on connection
- ✅ Save device preferences
- ✅ Connection history
- ✅ Per-device auto-play toggle
- ✅ Swipe to delete devices

## Technical Implementation

### Components
1. **BluetoothManager** (`RadioCar/Managers/BluetoothManager.swift`)
   - **Standard Bluetooth Audio detection** via AVAudioSession (all iOS versions)
   - **MFi accessory detection** via ExternalAccessory framework
   - Automatic saving of new devices (iOS 17+)
   - Playback start on connection (iOS 17+)
   - Monitors audio route changes for real-time status

2. **BluetoothDevice** (`RadioCar/Models/BluetoothDevice.swift`)
   - SwiftData model for persistence (iOS 17+)
   - Fields: identifier, name, autoPlay, lastConnectedDate

3. **BluetoothConnectionView** (`RadioCar/Views/BluetoothConnectionView.swift`)
   - Simplified UI for iOS 15-16
   - Connection status display
   - Currently connected devices list
   - Feature comparison information

4. **BluetoothSettingsView** (`RadioCar/Views/BluetoothSettingsView.swift`)
   - Full-featured UI for iOS 17+
   - Device management and auto-play toggles
   - Connection history and saved devices

### Info.plist Configuration
```xml
<key>UIBackgroundModes</key>
<array>
    <string>audio</string>
    <string>external-accessory</string>
</array>

<key>UISupportedExternalAccessoryProtocols</key>
<array>
    <string>com.apple.m1</string>
</array>

<key>NSBluetoothAlwaysUsageDescription</key>
<string>RadioCar needs Bluetooth access to automatically start playing when you connect your car audio system.</string>
```

## Troubleshooting

### Can't See the Settings Button
- Make sure the app is updated
- The button is on the left side, in the controls widget
- Gray button with gear icon (below Phone and Maps buttons)

### Auto-play Doesn't Work
1. Check that auto-play is enabled for your device
2. Make sure the device is successfully connected (check status in Bluetooth Settings)
3. Restart the app
4. Reconnect to the Bluetooth device

### Device Not Being Saved / No Auto-Play Option
- Auto-play and device storage require iOS 17.0+
- On iOS 15-16, you'll see BluetoothConnectionView with:
  - Current connection status
  - List of currently connected devices
  - Information about available features
- Manual playback still works on all iOS versions

## Technical Details

### How Bluetooth Detection Works

RadioCar uses two methods to detect Bluetooth connections:

1. **AVAudioSession Route Monitoring** (Standard Bluetooth):
   - Detects: `.bluetoothA2DP`, `.bluetoothLE`, `.bluetoothHFP`
   - Works with: All standard Bluetooth audio devices
   - Real-time updates via `AVAudioSession.routeChangeNotification`
   - Available: All iOS versions (15.8+)

2. **ExternalAccessory Framework** (MFi Accessories):
   - Detects: Only MFi-certified accessories
   - Requires: Apple certification in hardware
   - Updates via: `EAAccessoryDidConnect/Disconnect` notifications
   - Available: All iOS versions, but rare devices

### Why Two Methods?

Most car Bluetooth systems use **standard A2DP audio**, which iOS doesn't expose through ExternalAccessory. The AVAudioSession method allows us to detect when audio is routing through Bluetooth, giving real-time connection status for car audio systems, speakers, and headphones.

## Debugging
To verify functionality, open Console.app and filter by:
- `🔵` - all Bluetooth events
- `RadioCar` - general app logs

Example logs:
```
🔵 Bluetooth audio device connected: Car Audio
🔵 Bluetooth device connected: Car Audio (MFi)
🔵 Saved new Bluetooth device: Car Audio
🔵 Auto-play enabled for Car Audio
🔵 No Bluetooth audio device connected
```
