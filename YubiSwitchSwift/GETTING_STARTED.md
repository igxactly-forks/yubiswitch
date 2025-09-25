# YubiSwitch Swift - Getting Started

## Building the Project

### Prerequisites
- macOS 10.14 or later
- Xcode with Swift support
- IOKit framework access

### Quick Start
```bash
cd YubiSwitchSwift
swift build -c release
```

### Running the Demo (Cross-platform)
```bash
swift run
```

## macOS-Specific Build

To build a proper macOS app bundle, you'll need to:

1. Create an Xcode project from the Swift Package:
```bash
swift package generate-xcodeproj
open YubiSwitchSwift.xcodeproj
```

2. Configure app bundle settings:
   - Set deployment target to macOS 10.14
   - Add `Resources/Info.plist` as the app's Info.plist
   - Include `Resources/YubiSwitchSwift.sdef` for AppleScript support
   - Configure code signing

3. Build and run from Xcode for full macOS functionality

## Testing AppleScript Support

Once running on macOS, you can test the AppleScript commands:

```applescript
# Enable YubiKey
osascript -e 'tell application "YubiSwitchSwift" to KeyOn'

# Disable YubiKey
osascript -e 'tell application "YubiSwitchSwift" to KeyOff'

# Check status
osascript -e 'tell application "YubiSwitchSwift" to get status of yubikey'
```

## Extending the Implementation

### Adding Preferences
```swift
// Add to AppDelegate.swift
private func showPreferences() {
    let prefsController = PreferencesController()
    prefsController.showWindow(nil)
}
```

### Custom Device IDs
```swift
// Add to YubiKey.swift
struct YubiKeyConfig {
    let vendorID: UInt32
    let productID: UInt32
    let usagePage: UInt32
    let usage: UInt32
}

private func loadConfigFromDefaults() -> YubiKeyConfig {
    let defaults = UserDefaults.standard
    return YubiKeyConfig(
        vendorID: UInt32(defaults.string(forKey: "hotKeyVendorID")?.hexValue ?? 0x1050),
        productID: UInt32(defaults.string(forKey: "hotKeyProductID")?.hexValue ?? 0x0116),
        usagePage: 1,
        usage: 6
    )
}
```

### Helper Process Communication
```swift
// Add XPC service integration
import Foundation

class HelperCommunicator {
    private let connection = NSXPCConnection(serviceName: "com.pallotron.yubiswitch.helper")
    
    func enableDevice() async throws {
        let proxy = connection.remoteObjectProxy as! HelperProtocol
        try await proxy.enableYubiKey()
    }
}
```

## Architecture Extensions

The current scaffolding can be extended with:

1. **SwiftUI Preferences Window**
2. **Combine Framework for Reactive Programming**
3. **Swift Concurrency for Async Operations**
4. **Core Data for Advanced Settings Storage**
5. **Network Framework for Remote Management**

## Deployment

For distribution:

1. Configure code signing in Xcode
2. Enable hardened runtime
3. Add necessary entitlements for IOKit and AppleScript
4. Create installer package with helper registration
5. Submit for notarization

This Swift implementation provides a solid foundation that can be incrementally enhanced while maintaining the core yubiswitch functionality.