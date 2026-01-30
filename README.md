# GaitGuardAI 🛡️

GaitGuardAI is a watchOS app that monitors motion on an Apple Watch and provides rhythmic haptic cueing to help during gait initiation and turning, where freezing of gait can occur.

This project is intended as a cueing aid / prototype. It is not a medical device and should be tested with supervision before being relied on for safety-critical situations.

## What it does

### Automatic cueing:
- **Start assist**: detects attempts to start walking that don't turn into steps and plays a short metronome-like haptic cue.
- **Turn assist**: detects sustained turning motion without stepping and plays a slower cue to encourage controlled, staged turns.
- **Rhythmic haptics**: metronome-style pulses for a few seconds (different rhythm for start vs turn).
- **Cooldown**: prevents rapid re-triggering (reduces haptic "spam").
- **On-watch stats**: shows assists today and last assist time.
- **Clean watch UI**: single-screen design that fits smaller watches (e.g., Apple Watch SE).

### iPhone Companion App:
- **Live accelerometer data**: Real-time streaming of x, y, z motion data from watch to iPhone
- **Analytics dashboard**: Charts showing events by type, hour, and severity distribution
- **Live motion visualization**: Real-time chart displaying accelerometer data as it streams
- **Calibration results**: View baseline threshold, average, and standard deviation after calibration
- **Remote controls**: Adjust sensitivity, haptic patterns, and intensity from iPhone
- **Event timeline**: Real-time list of all assist events with timestamps

### Background Persistence:
- **HealthKit workout sessions**: Uses `HKWorkoutSession` to maintain background tracking even when watch screen is off
- **Extended runtime**: Continues monitoring during background execution
- **Battery optimization**: Smart session management to preserve battery life

### Calibration System:
- **30-second calibration**: Samples accelerometer data at 50Hz for personalized baseline
- **Automatic threshold calculation**: Computes average, standard deviation, and baseline threshold
- **Live data streaming**: Watch real-time motion data during calibration on iPhone
- **Adaptive detection**: Uses calibrated baseline for more accurate freeze detection

## Who it's for

This was built with real-world use in mind for someone who:

- has a foot that "sticks" when starting to walk
- struggles to turn without assistance
- may sometimes speed up / lean forward (festination)

## How detection works (high level)

The app runs a lightweight, on-device state machine driven by Core Motion:

### Sensors:
- `CMDeviceMotion` (using .xArbitraryZVertical)
- `userAcceleration` (gravity-removed movement)
- `rotationRate` (especially yaw for turning)

### Sampling: ~50Hz

### Step cadence proxy:
- detects peaks in acceleration magnitude over a rolling window to estimate cadence in Hz

### Initiation assist logic (simplified):
- if we see a small "attempt" movement after stillness but cadence stays low for ~1–2s, cue "Start"

### Turn assist logic (simplified):
- if we see sustained yaw rotation but cadence stays low, cue "Turn"

**Important**: thresholds are intentionally simple, and are designed to be tunable via Sensitivity.

## Calibration

The app includes a calibration mode to personalize detection thresholds:

1. **Tap "Calibrate"** on the watch
2. **Walk normally** for 30 seconds
3. **Automatic calculation**: The app samples at 50Hz and calculates:
   - Average movement magnitude
   - Standard deviation
   - Baseline threshold (mean + 2×stdDev)
4. **Results sync to iPhone**: View calibration results in the Analytics tab
5. **Adaptive detection**: Uses calibrated baseline for improved accuracy

## Wrist & wear guidance

Designed for right wrist use (as requested).

For best results:
- wear the watch snug (sensor signal is much worse when the watch is loose)
- start with short, supervised sessions to build trust
- complete calibration before first use for personalized thresholds

## Running on Apple Watch

### Prerequisites:
- Xcode 15+ (or latest)
- watchOS 10+ (or latest)
- iOS 17+ (or latest) for iPhone companion app
- Physical Apple Watch paired with iPhone (simulators don't support WatchConnectivity)

### Setup:
1. Open `GaitGuardAI/GaitGuardAI.xcodeproj` in Xcode
2. Select the scheme: **GaitGuard Watch App**
3. Select a run destination:
   - a Watch Simulator (for UI testing only - WatchConnectivity won't work)
   - your paired physical Apple Watch (recommended)
4. Press Run (⌘R)

### iPhone Companion:
1. Select the scheme: **GaitGuardAI-iPhone**
2. Run on a physical iPhone device
3. Both apps must be running on physical devices for WatchConnectivity to work

### If the app doesn't appear on your watch:
- In Xcode, ensure you are running **GaitGuard Watch App** (not only the iPhone target).
- On iPhone: open the Watch app → find GaitGuardAI → install / enable "Show App on Apple Watch".
- If icons or installs are stale: delete the app from the watch, Clean Build Folder, then run again.

### Connection Setup:
1. Launch both iPhone and Watch apps
2. Wait 5-60 seconds for WatchConnectivity session to activate
3. Watch app must be open and visible on watch screen
4. Keep watch unlocked and on your wrist
5. Connection status will show in iPhone app

## Safety notes (please read)

- **Turning difficulty can be a high fall-risk situation**. Use this as a cueing aid, not a replacement for supervision.
- If freezing/turning issues are severe, consider involving a clinician and a neuro/PT. Rhythmic cueing works best when paired with taught strategies (staged turns, weight shift, "big step").
- The app does not (yet) detect falls or call emergency contacts.
- **This is not a medical device** - use with supervision and professional guidance.

## Project structure

```
GaitGuardAI/
├── GaitGuardAI Watch App/
│   ├── ContentView.swift          # Watch UI
│   ├── MotionDetector.swift       # Motion processing, state machine, cueing
│   ├── GaitTrackingManager.swift  # HealthKit workout session management
│   └── GaitGuardAIApp.swift        # Watch app entry point
├── GaitGuardAI-iPhone/
│   ├── ContentView.swift           # iPhone main view (events list)
│   ├── AnalyticsView.swift        # Analytics dashboard with live charts
│   ├── RemoteControlsView.swift    # Settings and remote controls
│   └── GaitGuardAIiPhoneApp.swift # iPhone app entry point
├── Shared/
│   └── WatchConnectivityManager.swift  # Watch ↔ iPhone communication
└── SessionManager.swift           # WKExtendedRuntimeSession management
```

## Tuning

### On Watch:
- Open the app and adjust **Sensitivity**:
  - **Higher sensitivity**: cues sooner (more false positives)
  - **Lower sensitivity**: fewer cues (may miss subtle freezes)

### On iPhone:
- **Remote Controls** tab allows you to:
  - Adjust haptic intensity (0-100%)
  - Change haptic pattern (directionUp, notification, start, stop, click)
  - Toggle adaptive threshold (uses calibration if available)
  - Enable/disable repeat haptics
  - Test haptic trigger remotely

### Calibration:
- Complete calibration for personalized thresholds
- Calibration data syncs to iPhone automatically
- View results in Analytics tab

## Technical Highlights

- **Built with SwiftUI and Core Motion**
- **Uses WKExtendedRuntimeSession** for reliable background monitoring
- **HealthKit workout sessions** for persistent background tracking
- **WatchConnectivity** for real-time data streaming and event syncing
- **50Hz motion sampling** for high-precision detection
- **Live data streaming** at 10Hz to iPhone for real-time visualization
- **On-device processing** - all motion analysis happens on watch
- **Privacy-first**: No data leaves your devices

## Roadmap ideas

- [x] Calibration mode (30-second baseline walk) to personalize thresholds
- [x] iPhone companion dashboard via WatchConnectivity (timeline + trends)
- [x] Live accelerometer data streaming
- [x] HealthKit workout sessions for background persistence
- [ ] Better cadence/turn modeling (frequency features, per-axis energy, personalization)
- [ ] Fall detection
- [ ] Emergency contact integration
- [ ] Historical data export

## License

This project is licensed under the MIT License. See LICENSE for details.
