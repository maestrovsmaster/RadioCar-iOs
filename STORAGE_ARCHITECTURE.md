# Storage Architecture

## Overview

RadioCar uses different storage mechanisms depending on iOS version to ensure data persistence across all supported devices.

## Storage Strategy by iOS Version

### iOS 17+ (SwiftDataStationStorage)
- **Framework**: SwiftData
- **Storage**: SQLite database
- **Features**:
  - Full relational database
  - @Model classes with relationships
  - Automatic migrations
  - Query support with predicates

**Models**:
- `FavoriteStation` - Stores favorite station UUIDs with timestamps
- `RecentStation` - Stores recently played stations with play time
- `BluetoothDevice` - Stores Bluetooth device settings

### iOS 15-16 (UserDefaultsStationStorage)
- **Framework**: UserDefaults
- **Storage**: Property list (plist)
- **Features**:
  - Key-value storage
  - JSON encoding for complex objects
  - Synchronous access
  - Lightweight and fast

**Keys**:
- `RadioCar.Favorites` - Array of favorite station UUIDs
- `RadioCar.Recent` - Ordered array of recent station UUIDs
- `RadioCar.StationsCache` - JSON-encoded Station array

## Implementation Details

### UserDefaultsStationStorage

```swift
final class UserDefaultsStationStorage: LocalStationStorage {
    private let defaults = UserDefaults.standard
    private let favoritesKey = "RadioCar.Favorites"
    private let recentKey = "RadioCar.Recent"
    private let stationsCacheKey = "RadioCar.StationsCache"
}
```

#### Favorites Management

**Add to Favorites**:
```swift
func addToFavorites(stationUuid: String) async throws {
    var favorites = Set(defaults.stringArray(forKey: favoritesKey) ?? [])
    favorites.insert(stationUuid)
    defaults.set(Array(favorites), forKey: favoritesKey)
}
```

**Check if Favorite**:
```swift
func isFavorite(stationUuid: String) async throws -> Bool {
    let favorites = Set(defaults.stringArray(forKey: favoritesKey) ?? [])
    return favorites.contains(stationUuid)
}
```

#### Recent Stations Management

**Add to Recent** (maintains order, limit 50):
```swift
func addToRecent(stationUuid: String) async throws {
    var recent = defaults.stringArray(forKey: recentKey) ?? []
    recent.removeAll { $0 == stationUuid } // Remove if exists
    recent.insert(stationUuid, at: 0)      // Add to front
    if recent.count > 50 {
        recent = Array(recent.prefix(50))  // Keep only 50
    }
    defaults.set(recent, forKey: recentKey)
}
```

#### Station Cache (Optional)

Stores full station data for offline access:
```swift
func saveStations(_ stations: [Station]) async throws {
    if let encoded = try? JSONEncoder().encode(stations) {
        defaults.set(encoded, forKey: stationsCacheKey)
    }
}

func getCachedStations() async throws -> [Station] {
    guard let data = defaults.data(forKey: stationsCacheKey),
          let stations = try? JSONDecoder().decode([Station].self, from: data) else {
        return []
    }
    return stations
}
```

### SwiftDataStationStorage (iOS 17+)

Uses SwiftData models with automatic persistence:

```swift
@available(iOS 17.0, *)
@MainActor
final class SwiftDataStationStorage: LocalStationStorage {
    private let modelContext: ModelContext

    func addToFavorites(stationUuid: String) async throws {
        let favorite = FavoriteStation(stationuuid: stationUuid)
        modelContext.insert(favorite)
        try modelContext.save()
    }

    func isFavorite(stationUuid: String) async throws -> Bool {
        let descriptor = FetchDescriptor<FavoriteStation>(
            predicate: #Predicate { $0.stationuuid == stationUuid }
        )
        let count = try modelContext.fetchCount(descriptor)
        return count > 0
    }
}
```

## Data Persistence Guarantees

### UserDefaults (iOS 15-16)
- ✅ Persists across app launches
- ✅ Persists across device reboots
- ✅ Syncs to iCloud (if enabled by user)
- ✅ Atomic writes (no partial data)
- ⚠️ Limited to ~1MB recommended
- ⚠️ Not encrypted by default

### SwiftData (iOS 17+)
- ✅ Persists across app launches
- ✅ Persists across device reboots
- ✅ Supports large datasets
- ✅ Encrypted on device
- ✅ Automatic backups via iCloud
- ✅ Migration support

## Storage Selection Logic

Determined at initialization in `DefaultStationRepository`:

```swift
init(remote: RadioAPIService, storage: LocalStationStorage = UserDefaultsStationStorage()) {
    self.remote = remote
    self.storage = storage
}
```

For iOS 17+, can be explicitly set in `ContentView`:
```swift
if #available(iOS 17.0, *) {
    let storage = SwiftDataStationStorage(modelContext: context)
    let repository = DefaultStationRepository(remote: radioAPI, storage: storage)
} else {
    // Uses UserDefaultsStationStorage by default
    let repository = DefaultStationRepository(remote: radioAPI)
}
```

## Migration Path

When user upgrades from iOS 16 to iOS 17:

1. **Old data in UserDefaults** remains accessible
2. **New SwiftData storage** is initialized
3. **Manual migration** can be implemented:

```swift
@available(iOS 17.0, *)
func migrateFromUserDefaults(to swiftDataStorage: SwiftDataStationStorage) async throws {
    let userDefaultsStorage = UserDefaultsStationStorage()

    // Migrate favorites
    let favorites = try await userDefaultsStorage.getFavoriteStationUuids()
    for uuid in favorites {
        try await swiftDataStorage.addToFavorites(stationUuid: uuid)
    }

    // Migrate recent
    let recent = try await userDefaultsStorage.getRecentStationUuids()
    for uuid in recent {
        try await swiftDataStorage.addToRecent(stationUuid: uuid)
    }

    print("✅ Migrated \(favorites.count) favorites and \(recent.count) recent stations")
}
```

## Debugging Storage

### View UserDefaults Data

In Console.app or Xcode Console, look for:
```
💾 Using UserDefaults storage for iOS 15-16
💾 Saved 100 stations to UserDefaults
💾 Added to favorites: 961949f3-0601-11e8-ae97-52543be04c81
💾 Loaded 5 favorites from UserDefaults
💾 Added to recent: 961949f3-0601-11e8-ae97-52543be04c81
💾 Loaded 10 recent stations from UserDefaults
```

### Inspect UserDefaults (Debug)

```swift
// Print all RadioCar keys
let defaults = UserDefaults.standard
if let favorites = defaults.stringArray(forKey: "RadioCar.Favorites") {
    print("Favorites: \(favorites)")
}
if let recent = defaults.stringArray(forKey: "RadioCar.Recent") {
    print("Recent: \(recent)")
}
```

### Clear UserDefaults (for testing)

```swift
let defaults = UserDefaults.standard
defaults.removeObject(forKey: "RadioCar.Favorites")
defaults.removeObject(forKey: "RadioCar.Recent")
defaults.removeObject(forKey: "RadioCar.StationsCache")
print("🗑️ Cleared all RadioCar data from UserDefaults")
```

## Storage Limits

### UserDefaults
- **Recommended max**: 1 MB
- **Current usage estimate**:
  - 50 recent UUIDs: ~2 KB
  - 100 favorite UUIDs: ~4 KB
  - 100 cached stations: ~100 KB
  - **Total**: ~106 KB ✅

### SwiftData
- **Limit**: Device storage (GBs available)
- **Typical usage**: < 1 MB for favorites/recent

## Best Practices

1. **Keep UUIDs only** - Don't store full station objects unnecessarily
2. **Limit recent items** - Cap at 50 to avoid bloat
3. **Use Set for favorites** - O(1) lookup performance
4. **Async operations** - All storage operations are async
5. **Error handling** - Always handle storage errors gracefully

## Testing Storage

### Unit Test Example

```swift
func testUserDefaultsStorage() async throws {
    let storage = UserDefaultsStationStorage()

    // Add favorite
    try await storage.addToFavorites(stationUuid: "test-uuid-1")

    // Verify
    let isFavorite = try await storage.isFavorite(stationUuid: "test-uuid-1")
    XCTAssertTrue(isFavorite)

    // Remove
    try await storage.removeFromFavorites(stationUuid: "test-uuid-1")

    // Verify removed
    let stillFavorite = try await storage.isFavorite(stationUuid: "test-uuid-1")
    XCTAssertFalse(stillFavorite)
}
```

### Manual Testing

1. Add stations to favorites
2. Close app completely
3. Reopen app
4. Verify favorites are still there ✅

## Performance

### UserDefaults
- **Write speed**: Very fast (< 1ms)
- **Read speed**: Very fast (< 1ms)
- **Synchronous API**: Yes (wrapped in async)

### SwiftData
- **Write speed**: Fast (< 10ms)
- **Read speed**: Fast with indexes
- **Asynchronous**: Native async/await

## Security

### UserDefaults
- ⚠️ Not encrypted on device
- ⚠️ Accessible to jailbroken devices
- ✅ OK for non-sensitive data (station UUIDs)

### SwiftData
- ✅ Encrypted at rest (iOS default)
- ✅ Protected by device passcode
- ✅ Secure for all data types
