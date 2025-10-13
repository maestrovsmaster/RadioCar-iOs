# Bluetooth Device Icons Guide

## Overview

RadioCar automatically detects the type of Bluetooth device based on its name and displays an appropriate icon. This provides better visual feedback to users about what device they're connected to.

## Supported Device Types

### 🚗 Car Audio Systems
**Icon**: `car.fill`
**Triggers**: Device name contains:
- "car"
- "auto"
- "vehicle"

**Examples**:
- "Car Audio"
- "Toyota Audio"
- "My Car Stereo"
- "Vehicle Bluetooth"

**Display**:
```
🚗 Toyota Audio
   Car Audio System (A2DP)
   Connected ✓
```

---

### 🎧 AirPods
**Icons**:
- `airpods` - Regular AirPods
- `airpodspro` - AirPods Pro
- `airpodsmax` - AirPods Max

**Triggers**: Device name contains:
- "airpods" (base)
- "airpods" + "pro" (Pro)
- "airpods" + "max" (Max)

**Examples**:
- "AirPods"
- "John's AirPods Pro"
- "AirPods Max"

**Display**:
```
🎧 John's AirPods Pro
   AirPods
   Connected ✓
```

---

### 🎵 Beats Headphones
**Icon**: `beats.headphones`
**Triggers**: Device name contains:
- "beats"
- "powerbeats"
- "studio"

**Examples**:
- "Beats Solo"
- "Powerbeats Pro"
- "Studio Buds"

**Display**:
```
🎵 Beats Solo
   Beats Headphones
   Connected ✓
```

---

### 🎧 Generic Headphones
**Icon**: `headphones`
**Triggers**: Device name contains:
- "headphone"
- "headset"

**Examples**:
- "Sony Headphones"
- "Bose Headset"
- "Gaming Headphones"

**Display**:
```
🎧 Sony Headphones
   Bluetooth Headphones
   Connected ✓
```

---

### 🔊 Bluetooth Speakers
**Icon**: `hifispeaker.fill`
**Triggers**: Device name contains:
- "speaker"
- "boom"
- "soundbar"

**Examples**:
- "JBL Speaker"
- "UE Boom"
- "Soundbar"

**Display**:
```
🔊 JBL Speaker
   Bluetooth Speaker
   Connected ✓
```

---

### 🏠 HomePod
**Icon**: `homepod.fill`
**Triggers**: Device name contains:
- "homepod"

**Examples**:
- "HomePod"
- "HomePod mini"

**Display**:
```
🏠 HomePod
   HomePod
   Connected ✓
```

---

### 🎵 Default/Unknown Devices
**Icon**: `airpodspro` (default)
**Used when**: No specific keywords match

**Examples**:
- "Bluetooth Device"
- "BT-123"
- Any unrecognized device

**Display**:
```
🎵 Bluetooth Device
   Bluetooth Audio (A2DP)
   Connected ✓
```

---

## Implementation

### Code Location
`RadioCar/Views/BluetoothConnectionView.swift`

### Helper Functions

```swift
private func getBluetoothIcon(for deviceName: String?) -> String {
    guard let name = deviceName?.lowercased() else {
        return "speaker.wave.2.circle.fill"
    }

    // Car audio systems
    if name.contains("car") || name.contains("auto") || name.contains("vehicle") {
        return "car.fill"
    }

    // AirPods (with variants)
    if name.contains("airpods") {
        if name.contains("pro") { return "airpodspro" }
        if name.contains("max") { return "airpodsmax" }
        return "airpods"
    }

    // Beats
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

    // Default
    return "airpodspro"
}

private func getDeviceType(for deviceName: String?) -> String {
    // Returns descriptive text for the device type
    // e.g., "Car Audio System (A2DP)", "AirPods", etc.
}
```

## How It Works

1. **Device Connection**: When a Bluetooth device connects, iOS provides the device name via AVAudioSession
2. **Name Analysis**: The name is converted to lowercase and checked against keywords
3. **Icon Selection**: First matching keyword determines the icon
4. **Display**: The icon and device type are shown in the UI

## Priority Order

Icons are checked in this order (first match wins):
1. Car audio (highest priority for RadioCar app)
2. AirPods (with variant detection)
3. Beats
4. Generic headphones
5. Speakers
6. HomePod
7. Default (fallback)

## Adding New Device Types

To add support for a new device type:

1. Add the SF Symbol name to the icon check
2. Add keywords to match in device name
3. Add corresponding description text
4. Test with actual device

Example:
```swift
// Smartwatch
if name.contains("watch") || name.contains("galaxy watch") {
    return "applewatch"
}
```

## SF Symbols Used

All icons use Apple's SF Symbols, which are:
- ✅ Available on all iOS versions
- ✅ Automatically adapt to dark/light mode
- ✅ Scale properly with Dynamic Type
- ✅ Support accessibility features

### Icon Reference
- `car.fill` - Car
- `airpods` - Regular AirPods
- `airpodspro` - AirPods Pro
- `airpodsmax` - AirPods Max
- `beats.headphones` - Beats
- `headphones` - Generic headphones
- `hifispeaker.fill` - Speakers
- `homepod.fill` - HomePod
- `speaker.wave.2.circle.fill` - Default/fallback

## Testing

To test icon detection:
1. Connect different Bluetooth devices
2. Open Settings → Bluetooth in RadioCar
3. Verify correct icon appears
4. Check device type description

Common test cases:
- Car: "Toyota Audio" → 🚗
- AirPods: "John's AirPods Pro" → 🎧
- Speaker: "JBL Flip" → 🔊
- Unknown: "BT-Device" → 🎵 (default)
