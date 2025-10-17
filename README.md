# RadioCar iOS

<p float="left">
<img width="357" alt="RadioCar Main Screen" src="https://github.com/user-attachments/assets/radiocar-ios-main.png" />
<img width="357" alt="RadioCar Player" src="https://github.com/user-attachments/assets/radiocar-ios-player.png" />
</p>

## Overview
RadioCar is your ultimate car radio companion for iOS - a sleek SwiftUI application that streams thousands of radio stations worldwide with intelligent Bluetooth auto-play functionality. Designed specifically for in-car use with a beautiful dark interface and real-time speed display.

[![App Store](https://developer.apple.com/assets/elements/badges/download-on-the-app-store.svg)](https://apps.apple.com/app/radiocar/id6504000000)

## Features

### 🚗 Smart Bluetooth Auto-Play
- Automatically starts playing your last station when connected to your car's Bluetooth system
- Seamless integration with car audio systems
- Resume playback exactly where you left off

### 📻 Unlimited Radio Stations
- Access thousands of radio stations worldwide via [Radio Browser API](http://api.radio-browser.info)
- Real-time ICY metadata display (artist, song title)
- Background audio playback support

### 📍 Built-in Speedometer
- Real-time speed display using Core Location
- Optimized for safe viewing while driving
- Automatic location-based features

### ⭐ Smart Station Management
- Save favorite stations for quick access
- Recently played history
- Automatic station grouping by name

### 🔍 Advanced Search & Discovery
- Search by station name, country, or genre
- Filter by tags: Pop, Rock, Jazz, Classical, Electronic, Hip Hop, News, Sports, and more
- Country filters: Ukraine, USA, UK, Germany, France, Poland, Italy, Spain

### 🎚️ Beautiful UI
- Dark theme optimized for night driving
- Segmented volume control with visual feedback
- Lottie animations for enhanced user experience
- SwiftUI-native interface

### ⚙️ Customizable Settings
- Autoplay on launch toggle
- Last station persistence
- Privacy-focused design

### 🛡️ Safe & Responsible
- Content disclaimer on first launch
- Report functionality for inappropriate stations
- Server-side filtering for inappropriate content
- Privacy policy compliance

## Technical Stack

### Architecture
- **UI Framework:** SwiftUI
- **Architecture Pattern:** MVVM (Model-View-ViewModel)
- **State Management:** Combine + ObservableObject
- **Persistence:** SwiftData (iOS 17+) + UserDefaults
- **Networking:** URLSession with async/await
- **Audio:** AVFoundation (AVPlayer)
- **Location:** Core Location
- **Bluetooth:** Core Bluetooth

### Key Technologies
- **Swift 5.0**
- **iOS 15.8+ Support**
- **Lottie Animations** (via Swift Package Manager)
- **ICY Metadata Parsing**
- **Background Audio Modes**
- **Dependency Injection Container**

### Project Structure
```
RadioCar/
├── Core/
│   ├── API/           # Network layer (RadioAPIService)
│   ├── Cache/         # Station caching & persistence
│   ├── Constants/     # App constants & strings
│   ├── Database/      # SwiftData models & persistence
│   ├── DI/            # Dependency injection
│   ├── Filters/       # Content filtering (gitignored)
│   ├── Managers/      # Bluetooth, Audio, Location, Settings
│   └── Utils/         # Helper utilities
├── Models/            # Data models (Station, StationGroup)
├── Repository/        # Repository pattern implementation
├── ViewModels/        # MVVM view models
├── Views/             # SwiftUI views
├── Widgets/           # Reusable UI components
└── State/             # Global state management (PlayerState)
```

## APIs Used

### Radio Browser API
- **Endpoint:** `http://api.radio-browser.info`
- **Purpose:** Fetch radio stations by country, tag, search query
- **Documentation:** [Radio Browser API](http://api.radio-browser.info/#General)
- **Open Source:** Yes, community-driven radio directory

### ICY Metadata Protocol
- **Purpose:** Real-time song metadata extraction from radio streams
- **Implementation:** Custom HTTP header parsing

## Download
The app is available on the App Store. Download it here:

[![Download on App Store](https://developer.apple.com/assets/elements/badges/download-on-the-app-store.svg)](https://apps.apple.com/app/radiocar/id6504000000)

## Requirements
- **iOS:** 15.8 or later
- **Devices:** iPhone, iPad
- **Permissions:**
  - Bluetooth (for auto-play detection)
  - Location When In Use (for speedometer)
  - Network access (for streaming)

## Privacy & Security

### Data Collection
RadioCar respects your privacy:
- ✅ **No personal data collection** - No analytics, no tracking, no user accounts
- ✅ **Location used locally only** - Speed display only, never shared
- ✅ **Bluetooth used for detection only** - No data transmitted
- ✅ **No third-party advertising** - Clean, ad-free experience

### Privacy Policy
Read our full privacy policy: [radiocartunes.wixsite.com/radiocar/privacy](https://radiocartunes.wixsite.com/radiocar/privacy)

### Content Safety
- Server-side filtering for inappropriate stations
- User reporting system for flagged content
- Disclaimer acceptance required on first launch
- Compliance with App Store guidelines

## Building from Source

### Prerequisites
```bash
# Requirements
- Xcode 15.0 or later
- iOS 15.8+ Deployment Target
- Swift 5.0
- CocoaPods or SPM for dependencies
```

### Installation
```bash
# Clone the repository
git clone https://github.com/maestrovs/RadioCar-iOS.git
cd RadioCar-iOS

# Open in Xcode
open RadioCar.xcodeproj

# Dependencies are managed via Swift Package Manager
# Lottie will be fetched automatically on first build
```

### Configuration
1. **Bundle ID:** Change `maestrovs.RadioCar` to your own
2. **Development Team:** Set your Apple Developer team in Xcode
3. **Code Signing:** Automatic signing recommended
4. **Info.plist:** Privacy descriptions are pre-configured

### Build & Run
```bash
# Build for simulator
xcodebuild -project RadioCar.xcodeproj -scheme RadioCar -sdk iphonesimulator

# Or simply press Cmd+R in Xcode
```

## Architecture Highlights

### Dependency Injection
```swift
class DependencyContainer: ObservableObject {
    lazy var radioAPI: RadioAPIService = RadioAPIService()
    lazy var stationRepository: StationRepository = DefaultStationRepository(remote: radioAPI)
    // ... other dependencies
}
```

### State Management
```swift
// Global player state using Combine
final class PlayerState: ObservableObject {
    static let shared = PlayerState()
    @Published var currentStation: Station?
    @Published var isPlaying: Bool = false
    @Published var songMetadata: String?
    // ... reactive state properties
}
```

### Repository Pattern
```swift
protocol StationRepository {
    func fetchStationGroups(...) async throws -> [StationGroup]
    func searchStationGroups(...) async throws -> [StationGroup]
    func addToFavorites(...) async throws
}
```

### Caching Strategy
- **StationCache:** In-memory cache with TTL
- **LastStationCache:** UserDefaults persistence
- **FavoriteStation:** SwiftData persistence (iOS 17+)

## Roadmap

### Version 1.1 (Planned)
- [ ] CarPlay support
- [ ] Sleep timer
- [ ] Equalizer settings
- [ ] Station recommendations

### Version 1.2 (Future)
- [ ] Podcast support
- [ ] Cross-device favorites sync (iCloud)
- [ ] Widgets for Home Screen
- [ ] Apple Watch companion app

## Contributions

We welcome contributions! Here's how you can help:

### Ways to Contribute
1. **Report Bugs:** Open an issue with detailed steps to reproduce
2. **Request Features:** Suggest new features via issues
3. **Submit Pull Requests:** Code contributions are welcome!
4. **Improve Documentation:** Help us improve docs and comments
5. **Test & Feedback:** Try the app and provide feedback

### Pull Request Guidelines
1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Follow SwiftUI and Swift coding conventions
4. Add tests if applicable
5. Update documentation
6. Commit your changes (`git commit -m 'Add amazing feature'`)
7. Push to the branch (`git push origin feature/amazing-feature`)
8. Open a Pull Request

### Code Style
- Follow Swift API Design Guidelines
- Use SwiftLint for linting (configuration included)
- Document public APIs with DocC-style comments
- Keep functions focused and testable

## Known Issues

- Some radio stations may be temporarily offline (community-driven sources)
- ICY metadata may not be available for all streams
- Bluetooth auto-play requires proper Bluetooth permissions

## Feedback & Support

### Contact
- **Email:** radiocar.tunes@gmail.com
- **Issues:** [GitHub Issues](https://github.com/maestrovs/RadioCar-iOS/issues)
- **Discussions:** [GitHub Discussions](https://github.com/maestrovs/RadioCar-iOS/discussions)

### Report a Station
If you encounter inappropriate content:
1. Tap the 🚩 Report button next to the station
2. This will open an email with station details
3. We review all reports and update filters accordingly

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- **Radio Browser API** - For providing free, community-driven radio station directory
- **Lottie by Airbnb** - Beautiful animations
- **Community Contributors** - Thank you for your support!

## Platform Availability

| Platform | Status | Link |
|----------|--------|------|
| 🍎 iOS | Available | [App Store](https://apps.apple.com/app/radiocar/id6504000000) |
| 🤖 Android | Available | [Play Store](https://play.google.com/store/apps/details?id=com.maestrovs.radiocar) |

## Screenshots

### Main Features
| Speedometer & Player | Station List | Search & Explore | Settings |
|---------------------|--------------|------------------|----------|
| <img src="screenshots/main.png" width="200"> | <img src="screenshots/list.png" width="200"> | <img src="screenshots/search.png" width="200"> | <img src="screenshots/settings.png" width="200"> |

> Note: Screenshots to be added after App Store approval

---

## API Usage Guidelines

**Important:** Please respect the Radio Browser API usage guidelines:
- This is a community-driven, free API
- Do not spam requests
- Cache results when possible (we implement caching)
- Consider donating to support the service

---

## Version History

### 1.0 (2025-10-17) - Initial Release
- ✨ First public release
- 🚗 Bluetooth auto-play functionality
- 📻 Thousands of streaming radio stations
- 📍 Real-time speedometer
- ⭐ Favorites and recent stations
- 🔍 Advanced search with filters
- 🌓 Dark theme optimized for driving
- ⚙️ Autoplay settings
- 🛡️ Content disclaimer and reporting

---

**Made with ❤️ by Maestro Creations**

© 2025 Maestro Creations. All rights reserved.

---

> **Note:** This is the iOS version of RadioCar. For the Android version, visit [RadioCar Android Repository](https://github.com/maestrovs/RadioCar).

Looking forward to your contributions and suggestions! 🚀
