# RadioCar iOS - App Store Submission Checklist

**Last Updated:** 2025-10-17
**Version:** 1.0 (Build 1)
**Status:** 75% Ready - Critical fixes applied

---

## ✅ COMPLETED - Critical Fixes Applied

- [x] **Removed `exit(0)` force quit** - Replaced with `DisclaimerView` that blocks UI until accepted
- [x] **Removed "Always" location permission** - Now only requests "When In Use"
- [x] **Added ATS justification** - XML comment in Info.plist explaining HTTP streaming necessity
- [x] **Updated TODO comments** - App Store URL comment clarified
- [x] **Disclaimer implementation** - Full-screen view on first launch, prevents app use until accepted

---

## 🔴 CRITICAL - Must Complete Before Submission

### 1. Privacy Policy URL Verification
**Status:** ⚠️ NEEDS VERIFICATION
**Action Required:**
- [ ] Open https://radiocartunes.wixsite.com/radiocar/privacy in Safari on iPhone
- [ ] Verify page loads and displays privacy policy content
- [ ] Ensure policy covers:
  - Location data usage (speed display while driving)
  - Bluetooth connectivity
  - Third-party radio content sources (radio-browser.info)
  - No personal data collection claims
  - User rights (GDPR/CCPA if applicable)

**If policy is not accessible:** Create simple HTML page on GitHub Pages or update Wix site.

---

### 2. App Store Screenshots
**Status:** ❌ NOT CREATED
**Required Sizes:**

#### iPhone Screenshots (REQUIRED):
- [ ] **iPhone 6.7"** (1290 x 2796 pixels) - iPhone 15 Pro Max, 14 Pro Max
  - Minimum 3 screenshots, max 10
  - Show: Main screen, Player, Station list, Search/Explore, Settings

- [ ] **iPhone 6.5"** (1242 x 2688 pixels) - iPhone 11 Pro Max, XS Max
  - Same 3-10 screenshots as above

#### iPad Screenshots (if supporting iPad):
- [ ] **iPad Pro 12.9"** (2048 x 2732 pixels)
  - Minimum 3 screenshots

**Screenshot Content Ideas:**
1. Main screen with speedometer and player
2. Station list with favorites
3. Search/Explore screen with filters
4. Player with station playing and metadata
5. Settings screen with autoplay option
6. Bluetooth connection feature

**Tools:** Use Xcode Simulator → Window → Screenshot

---

### 3. App Store Connect Metadata
**Status:** ❌ NOT CREATED

#### App Information:
- [ ] **App Name:** RadioCar (30 char max)
- [ ] **Subtitle:** "Car Radio Streaming with Bluetooth" (30 char max, example)
- [ ] **Primary Category:** Entertainment or Music
- [ ] **Secondary Category:** (optional)

#### Description (4000 char max):
```
RadioCar: Your Ultimate Car Radio Companion

Transform your driving experience with RadioCar - the smart car radio app that combines thousands of streaming radio stations with intelligent Bluetooth connectivity.

KEY FEATURES:

🚗 Smart Bluetooth Auto-Play
Automatically starts playing your last station when you connect to your car's Bluetooth system. Just start your car and drive!

📻 Unlimited Radio Stations
Access thousands of radio stations worldwide from radio-browser.info's open database. Discover music, news, talk shows, sports, and more.

🎵 Real-Time Metadata
See what's playing with live song information and artist names displayed directly in the app.

📍 Speed Display
Built-in speedometer shows your current speed while driving (requires location permission).

⭐ Favorites & Recent
Save your favorite stations for quick access and view your recently played history.

🔍 Advanced Search
Find stations by country, genre tags (pop, rock, jazz, classical, electronic, hip hop, news, sports, and more), or station name.

🎚️ Volume Control
Beautiful segmented volume bar designed for easy adjustment while driving.

🌓 Dark-Optimized Interface
Sleek dark theme designed specifically for in-car use - easy on the eyes during night driving.

⚙️ Autoplay Settings
Choose whether to automatically play your last station on app launch.

SAFE & RESPONSIBLE:
RadioCar displays a disclaimer on first use and includes a reporting feature for any inappropriate content. All content comes from third-party public sources.

REQUIREMENTS:
- iOS 15.8 or later
- Bluetooth-enabled car audio system (optional but recommended)
- Internet connection for streaming

Privacy: We respect your privacy. Location is only used for speed display, and Bluetooth is only for auto-play detection. No personal data is collected or shared.

Download RadioCar today and enjoy seamless radio streaming on every drive!
```

- [ ] **Keywords** (100 char, comma-separated):
```
car radio,streaming,bluetooth,radio player,car audio,music,news,FM,AM,internet radio,road trip
```

- [ ] **Support URL:** Need a support page or use email: radiocar.tunes@gmail.com
- [ ] **Marketing URL:** (optional) - can use privacy policy URL
- [ ] **Promotional Text** (170 char, updatable anytime):
```
Stream thousands of radio stations while driving. Auto-plays when you connect to your car's Bluetooth. Your perfect road trip companion!
```

- [ ] **What's New in Version 1.0** (4000 char):
```
Welcome to RadioCar 1.0!

This is the first release of RadioCar, bringing you:

• Bluetooth auto-play when connecting to your car
• Thousands of streaming radio stations worldwide
• Real-time song metadata display
• Built-in speedometer
• Favorites and recent stations
• Advanced search with country and genre filters
• Dark theme optimized for driving
• Background audio playback
• Autoplay settings

Thank you for downloading RadioCar. We hope you enjoy your drives!

Have feedback? Contact us at radiocar.tunes@gmail.com
```

---

### 4. Age Rating Questionnaire
**Status:** ❌ NOT COMPLETED

**Expected Rating:** 4+ or 9+

**Answers:**
- [ ] Cartoon or Fantasy Violence: None
- [ ] Realistic Violence: None
- [ ] Prolonged Graphic or Sadistic Realistic Violence: None
- [ ] Profanity or Crude Humor: Infrequent/Mild (third-party content)
- [ ] Mature/Suggestive Themes: None
- [ ] Horror/Fear Themes: None
- [ ] Medical/Treatment Information: None
- [ ] Alcohol, Tobacco, or Drug Use: None
- [ ] Simulated Gambling: None
- [ ] Sexual Content or Nudity: None
- [ ] Graphic Sexual Content and Nudity: None
- [ ] **Unrestricted Web Access:** YES (radio streams from third-party sources)
- [ ] **User Generated Content:** No (content is pre-existing radio streams)

**Notes for Review:**
- App streams radio content from public third-party sources
- Disclaimer shown on first launch
- User can report inappropriate content
- Content filtering implemented (see StationFilters.swift)

---

### 5. App Review Information
**Status:** ❌ NOT COMPLETED

Fill out in App Store Connect:
- [ ] **First Name:** [Your Name]
- [ ] **Last Name:** [Your Last Name]
- [ ] **Phone Number:** [Your Phone]
- [ ] **Email:** radiocar.tunes@gmail.com
- [ ] **Demo Account:** Not required for RadioCar

**Notes for Reviewer:**
```
App Transport Security (NSAllowsArbitraryLoads):

RadioCar requires NSAllowsArbitraryLoads=true because the app streams radio content from thousands of third-party radio station URLs sourced from radio-browser.info (a community-driven open radio directory). Many community and independent radio stations only provide HTTP streaming URLs, not HTTPS.

The app does not transmit any user data over HTTP. HTTP is only used for receiving audio streams from third-party radio stations.

Third-Party Content:

All radio content comes from radio-browser.info API. The app displays a disclaimer on first launch explaining that content is from third-party sources. Users can report inappropriate content via the report button next to each station. The app also implements server-side filtering to block known inappropriate stations.

Testing Instructions:

1. On first launch, accept the disclaimer
2. Browse or search for radio stations
3. Tap a station to start playing
4. Use Bluetooth auto-play by connecting to a Bluetooth audio device
5. Test favorites, recent stations, and search features

Location permission is only used for the speedometer display. Bluetooth permission is only used for auto-play detection when connecting to car audio systems.
```

---

## 🟡 RECOMMENDED - Should Complete

### 6. Code Quality Improvements

#### Debug Print Statements (84 found):
Files with most prints:
- AudioPlayerManager.swift
- BluetoothManager.swift
- LocationSpeedManager.swift
- RadioAPIService.swift

**Recommendation:** Wrap in `#if DEBUG` blocks:
```swift
#if DEBUG
print("Debug message here")
#endif
```

#### FatalError Handling (2 found):
- RadioCarApp.swift:37 - ModelContainer initialization
- PersistenceController.swift:19 - Store loading

**Current (risky):**
```swift
} catch {
    fatalError("Could not create ModelContainer: \(error)")
}
```

**Better (graceful):**
```swift
} catch {
    print("Error creating ModelContainer: \(error)")
    // Show error UI or use in-memory fallback
    return try! ModelContainer(for: schema, configurations: [
        ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
    ])
}
```

---

### 7. Testing Checklist

Before submission, test:
- [ ] Fresh install on physical device (delete app first)
- [ ] Disclaimer appears and blocks app until accepted
- [ ] Browse stations and play successfully
- [ ] Bluetooth auto-play works with car/headphones
- [ ] Location permission request appears
- [ ] Speedometer displays correctly
- [ ] Add to favorites works
- [ ] Search/Explore works
- [ ] Background audio continues playing
- [ ] Volume control works
- [ ] Report button opens email
- [ ] Settings > Autoplay toggle works
- [ ] Last station loads on app restart
- [ ] App works on iOS 15.8, 16.x, 17.x, 18.x
- [ ] Test on various screen sizes (SE, standard, Plus, Max)

---

## 📱 NEXT STEPS - Priority Order

### Week 1: Preparation
1. ✅ Fix critical issues (COMPLETED)
2. Verify privacy policy URL is accessible
3. Create screenshots (3-10 per device size)
4. Write final app description and metadata

### Week 2: App Store Connect
5. Create app listing in App Store Connect
6. Upload screenshots and icon
7. Fill out all metadata fields
8. Complete age rating questionnaire
9. Add App Review Information with notes
10. Update App Store URL in AppConstants.swift with actual ID

### Week 3: Final Testing & Submission
11. Test on physical devices (multiple iOS versions)
12. Remove debug prints (optional but recommended)
13. Archive and upload build to App Store Connect
14. Submit for review

### Expected Timeline:
- **Preparation:** 2-3 days
- **App Store Connect setup:** 1 day
- **Testing:** 2-3 days
- **Review process:** 1-3 days (Apple's timeline)

**Total estimated time to approval:** 1-2 weeks

---

## 📝 Additional Notes

### App Store Review Notes (to copy-paste):
```
IMPORTANT INFORMATION FOR REVIEWER:

1. HTTP Streaming (ATS): This app requires HTTP streaming for third-party radio stations. Many independent radio stations do not provide HTTPS streams. No user data is transmitted over HTTP.

2. Third-Party Content: All radio content is from radio-browser.info. Users are shown a disclaimer and can report inappropriate content.

3. Bluetooth Permission: Used only for auto-play detection when connecting to car audio.

4. Location Permission: Used only to display speed in the speedometer widget.

5. Testing: Please test with various radio stations. Some stations may be temporarily offline (this is normal for community radio). Try different countries and genres in the Explore tab.

Thank you for reviewing RadioCar!
```

---

## 🎯 Confidence Level: 75%

**Likely approval after addressing:**
- Privacy policy verification
- Screenshot creation
- Metadata completion

**Main uncertainty:**
- ATS approval for HTTP streaming (explained in notes)
- Third-party content handling (disclaimer + reporting helps)

---

## 📧 Contact

**Developer Email:** radiocar.tunes@gmail.com
**Privacy Policy:** https://radiocartunes.wixsite.com/radiocar/privacy
**Support:** radiocar.tunes@gmail.com

---

**Good luck with your submission! 🚀**
