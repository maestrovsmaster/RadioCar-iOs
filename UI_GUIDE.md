# RadioCar UI Guide - Where to Find the Settings Button

## Main Screen (ContentView)

```
┌─────────────────────────────────────┐
│   [📞]              ┌─────────────┐ │
│                    │             │ │
│   [🗺️]              │  Station    │ │ ← MediumPlayerWidget
│                    │  Info       │ │
│   [⚙️] ← HERE!      │  & Controls │ │ ← Settings button (gear)
│                    │             │ │
│                    └─────────────┘ │
├─────────────────────────────────────┤
│                                     │
│  [All] [Favorites] [Recent]         │
│                                     │
│  📻 Station 1              ♥        │
│  📻 Station 2              ♡        │
│  📻 Station 3              ♥        │
│  ...                                │
│                                     │
└─────────────────────────────────────┘
```

## Settings Button Details

**Appearance:**
- Gray color (system gray)
- Icon: gearshape.fill
- Icon size: 20pt
- Background: Gray circle
- Located in ControlsWidget (left side)

**Code:**
```swift
ControlIconButton(systemName: "gearshape.fill", color: .gray) {
    print("⚙️ Settings button tapped")
    onSettingsTap?()
}
```

**ControlIconButton Implementation:**
```swift
Button(action: action) {
    Image(systemName: systemName)
        .font(.system(size: 20))
        .foregroundColor(.white)
        .padding()
        .background(Circle().fill(color))
}
```

## Bluetooth Settings Screen

When you tap the button, a sheet opens with:

```
┌─────────────────────────────────────┐
│ ← Bluetooth Settings                │
├─────────────────────────────────────┤
│ Connection Status                   │
│ ┌─────────────────────────────────┐ │
│ │ 🔵 Bluetooth Status             │ │
│ │    Connected: Car Audio ✓       │ │
│ └─────────────────────────────────┘ │
├─────────────────────────────────────┤
│ Saved Devices                       │
│ ┌─────────────────────────────────┐ │
│ │ 🔊 Car Audio                    │ │
│ │    XX:XX:XX:XX:XX:XX • Connected│ │
│ │    Last connected: 13/10 12:30  │ │
│ │                      Auto-play  │ │
│ │                         [ON] ←  │ │ ← Enable here!
│ └─────────────────────────────────┘ │
│ ┌─────────────────────────────────┐ │
│ │ 🔊 Home Bluetooth               │ │
│ │    YY:YY:YY:YY:YY:YY            │ │
│ │    Last connected: 12/10 18:45  │ │
│ │                      Auto-play  │ │
│ │                        [OFF]    │ │
│ └─────────────────────────────────┘ │
├─────────────────────────────────────┤
│ How it works                        │
│ ① Connect your Bluetooth device     │
│ ② Device will be saved automatically│
│ ③ Toggle auto-play for your device  │
│ ④ Radio starts playing when connected│
└─────────────────────────────────────┘
```

## How to Enable Auto-Play

### Step 1: Tap the Settings Button
```
Main Screen → [⚙️] (left side, gray gear icon)
```

### Step 2: Find Your Device
```
Bluetooth Settings → Saved Devices → Your Car
```

### Step 3: Enable Auto-play
```
Tap the [OFF] toggle → it becomes [ON]
```

### Step 4: Done!
```
Now when connecting to this device, the radio
will automatically start playing the last station
```

## Color Scheme

- **Background**: Black (#000000)
- **Text**: White (#FFFFFF)
- **Phone button**: Green (system green)
- **Maps button**: Blue (system blue)
- **Settings button**: Gray (system gray)
- **Connected status**: Green (system green)
- **Secondary text**: Gray (system secondary)

## File Locations

```
RadioCar/
├── ContentView.swift                    ← Main screen with button
├── Views/
│   └── BluetoothSettingsView.swift     ← Settings screen
├── Managers/
│   └── BluetoothManager.swift          ← Bluetooth logic
└── Models/
    └── BluetoothDevice.swift           ← Device model
```

## What Happens Under the Hood

1. **When Bluetooth Connects:**
   ```
   Car connects → EAAccessoryDidConnect notification
   → BluetoothManager.accessoryDidConnect()
   → Save to database if new
   → Check if autoPlay == true
   → If yes → Start playing
   ```

2. **When Button is Tapped:**
   ```
   User taps [🔵] → showBluetoothSettings = true
   → Sheet appears with BluetoothSettingsView
   → Load devices from database
   → Display list with toggles
   ```

3. **When Auto-play Changes:**
   ```
   User toggles switch → bluetoothManager.toggleAutoPlay()
   → Update device.autoPlay in database
   → Save context
   → Next connection will auto-play
   ```

## Tips

✅ **Settings Button is Always Visible**
- No need to scroll
- Always on the left side in ControlsWidget
- Gray gear icon below Phone and Maps buttons

✅ **Auto-play Works in Background**
- Even if the app is closed
- Uses background mode 'external-accessory'
- Triggers on connection detection

✅ **Multiple Devices Supported**
- Each with its own auto-play setting
- Automatic detection of current device
- Connection history (lastConnectedDate)
