# Speedometer Card Feature

## Overview

SpeedometerCard is a digital dashboard widget inspired by Android Auto that displays real-time driving information including speed, location, weather, and Bluetooth status.

## Features

### 🚗 Digital Speedometer
- **Real-time GPS speed** display in km/h
- Large, easy-to-read digital format (56pt font)
- Shows "-- --" when stationary (< 0.5 km/h)
- Updates automatically as you drive
- Automotive-grade accuracy using `kCLLocationAccuracyBestForNavigation`

### 📍 Location Display
- **Automatic location detection** via reverse geocoding
- Shows city/locality name (e.g., "Eyemouth")
- Cyan color for visibility
- Updates when moving to new locations
- Location icon indicator

### ☁️ Weather Information
- Temperature display
- Weather icon (sun, cloud, rain, etc.)
- Auto-updates (placeholder for API integration)
- Top-left corner placement

### 🔵 Bluetooth Status
- Shows connected device name
- Blue Bluetooth icon
- Displays "Connected" if no name available
- Top-right corner placement

### 🎨 Design Elements
- **Road scene background** with mountains and perspective lines
- **Dark gradient** (blue-gray tones)
- **Rounded corners** (20pt radius)
- **Shadow** for depth
- **Responsive layout** adapts to screen size

## Architecture

### Components

#### 1. LocationSpeedManager
**File**: `RadioCar/Managers/LocationSpeedManager.swift`

Singleton class managing GPS and location services:

```swift
class LocationSpeedManager: NSObject, ObservableObject {
    @Published var currentSpeed: Double = 0.0 // km/h
    @Published var currentLocation: String = "---"
    @Published var isAuthorized: Bool = false
}
```

**Features**:
- CoreLocation integration
- Speed conversion (m/s → km/h)
- Reverse geocoding for place names
- Authorization handling
- Automotive navigation mode

#### 2. SpeedometerCard
**File**: `RadioCar/Widgets/SpeedometerCard.swift`

SwiftUI view displaying all information:

```swift
struct SpeedometerCard: View {
    @ObservedObject private var locationManager = LocationSpeedManager.shared
    @ObservedObject private var bluetoothManager = BluetoothManager.shared
    @StateObject private var weatherManager = WeatherManager()
}
```

**Layout**:
```
┌─────────────────────────────────────┐
│ ☁️ 18°C              🔵 Car  [⏻]   │ ← Top bar
│                                     │
│         ┌───────────────┐           │
│         │   Mountains   │           │
│         │   /\  /\  /\  │           │
│         │  Road Lines   │           │ ← Road scene
│         │     \  /      │           │
│         └───────────────┘           │
│                                     │
│           56                        │ ← Speed
│          km/h                       │
│                                     │
│      📍 Eyemouth                    │ ← Location
└─────────────────────────────────────┘
```

#### 3. RoadSceneView
Decorative background showing:
- Mountain silhouettes
- Perspective road lines (dashed)
- Depth perception with gradients

#### 4. WeatherManager
**File**: `RadioCar/Widgets/SpeedometerCard.swift` (embedded)

Simple weather data manager:

```swift
class WeatherManager: ObservableObject {
    @Published var temperature: String = "- -°C"
    @Published var weatherIcon: String = "cloud.fill"

    func fetchWeather() {
        // Placeholder for API integration
    }
}
```

## Permissions

### Info.plist Configuration

```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>RadioCar needs your location to display your current speed and location while driving.</string>

<key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
<string>RadioCar needs your location to display your current speed and location while driving.</string>
```

### Authorization Flow

1. User opens app → Location permission dialog appears
2. User grants "While Using App" → Speedometer activates
3. Speed and location update in real-time
4. If denied → Shows location icon with slash, speed shows "-- --"

## Integration

### ContentView Integration

```swift
VStack(spacing: 8) {
    // Speedometer Card at the top
    SpeedometerCard()
        .padding(.horizontal, 16)
        .padding(.top, 8)

    // Rest of UI below
    HStack {
        ControlsWidget(...)
        MediumPlayerView()
    }

    StationListView(...)
}
```

**Height**: 200pt fixed
**Position**: Top of screen, above controls and player

## Speed Calculation

### GPS to km/h Conversion

```swift
// CLLocation provides speed in m/s
let speedInMetersPerSecond = location.speed // -1 if invalid
let speedInKmh = speedInMetersPerSecond * 3.6

// Validation
if speedInMetersPerSecond >= 0 {
    self.currentSpeed = speedInKmh
}
```

### Display Logic

```swift
private func formatSpeed(_ speed: Double) -> String {
    if speed < 0.5 {
        return "-- --"  // Stationary
    }

    let speedInt = Int(speed)
    if speedInt < 10 {
        return String(format: "0%d", speedInt)  // "01", "09"
    } else {
        return String(format: "%02d", speedInt) // "12", "56"
    }
}
```

**Examples**:
- 0.0 km/h → `-- --`
- 0.3 km/h → `-- --`
- 5 km/h → `05`
- 15 km/h → `15`
- 120 km/h → `120`

## Location Updates

### Update Strategy

```swift
locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
locationManager.distanceFilter = 10  // Update every 10 meters
locationManager.activityType = .automotiveNavigation
```

**Optimizations**:
- Only geocode once or when significantly moved
- Throttle reverse geocoding to avoid rate limits
- Use city/locality names (not full addresses)

### Geocoding Priority

```swift
let locationName = placemark.locality          // "New York"
    ?? placemark.subLocality                   // "Manhattan"
    ?? placemark.administrativeArea            // "NY"
    ?? "Unknown"
```

## Weather Integration (Placeholder)

### Current Implementation

Static placeholder showing demo data:
```swift
DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
    self.temperature = "18°C"
    self.weatherIcon = "cloud.sun.fill"
}
```

### Future API Integration

Can be extended with OpenWeatherMap, WeatherKit, or similar:

```swift
func fetchWeather() async {
    // Get current location
    guard let location = locationManager.currentLocation else { return }

    // Call weather API
    let url = "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=YOUR_KEY"

    // Update published properties
    self.temperature = "\(temp)°C"
    self.weatherIcon = weatherConditionToIcon(condition)
}
```

## SF Symbols Used

### Weather Icons
- `cloud.fill` - Cloudy
- `cloud.sun.fill` - Partly cloudy
- `sun.max.fill` - Sunny
- `cloud.rain.fill` - Rainy
- `cloud.snow.fill` - Snowy

### Status Icons
- `bluetooth.connected` - Bluetooth active
- `location.fill` - Location enabled
- `location.slash` - Location disabled
- `power` - Power button (decorative)

## Performance

### Battery Impact
- **GPS**: Continuous usage drains battery
- **Mitigation**: Only active when app in foreground
- **Auto-stop**: Stops location updates when app backgrounded

### CPU Usage
- **Location updates**: Minimal (system-managed)
- **UI updates**: 60 FPS smooth
- **Geocoding**: Async, non-blocking

## Testing

### Simulator Testing
⚠️ Simulator limitations:
- No real GPS data
- Use Xcode → Debug → Simulate Location
- Choose "City Run" or "Freeway Drive" for speed simulation

### Device Testing
1. Run on physical device
2. Allow location permissions
3. Drive or walk to see speed updates
4. Speed updates in real-time
5. Location name changes when crossing city boundaries

### Debug Logs

Look for:
```
📍 Started updating location and speed
📍 Speed: 45 km/h
📍 Location: Kyiv
```

## Customization

### Colors

```swift
// Background gradient
Color(red: 0.2, green: 0.25, blue: 0.35)  // Top
Color(red: 0.15, green: 0.2, blue: 0.28)  // Bottom

// Location text
.foregroundColor(.cyan)

// Speed text
.foregroundColor(.white)
```

### Fonts

```swift
// Speed
.font(.system(size: 56, weight: .light, design: .rounded))
.tracking(8)  // Letter spacing

// km/h label
.font(.title3)
```

### Sizing

```swift
.frame(height: 200)  // Card height
.cornerRadius(20)    // Rounded corners
```

## Known Limitations

1. **Weather**: Placeholder only (no real API)
2. **GPS Accuracy**: Depends on device GPS chip
3. **Speed Limit**: No speed limit warnings
4. **Units**: km/h only (no mph option yet)
5. **Background**: Location stops when app backgrounded

## Future Enhancements

- [ ] mph/km/h unit toggle
- [ ] Real weather API integration (OpenWeather/WeatherKit)
- [ ] Speed limit warnings
- [ ] Average speed calculation
- [ ] Trip distance counter
- [ ] Speed history graph
- [ ] Dark/light mode support
- [ ] Background location (with proper justification)

## Safety Notice

⚠️ **IMPORTANT**: This speedometer is for informational purposes only. Always follow traffic laws and use your vehicle's built-in speedometer as the primary reference. Do not interact with your phone while driving.
