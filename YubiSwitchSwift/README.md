# YubiSwitch Swift Rewrite

## Overview

This is a Swift rewrite of the original Objective-C `yubiswitch` macOS status bar application. The goal is to port the core functionalities while leveraging Swift's modern language features and native AppKit support.

## Architecture

### Core Components

1. **AppDelegate.swift** - Main application controller
   - Manages the status bar item and menu
   - Handles user interactions (enable/disable toggle)
   - Manages notifications and state updates
   - Implements auto-disable timer functionality
   - Provides AppleScript support interface

2. **YubiKey.swift** - USB device management
   - Interfaces with IOKit HID framework
   - Manages device detection and state
   - Handles enable/disable operations via exclusive USB access
   - Monitors device insertion/removal events
   - Provides callback interface for device events

### Key Features Implemented

- ✅ Status bar menu with enable/disable toggle
- ✅ User notifications for state changes
- ✅ Basic YubiKey USB device detection structure
- ✅ Auto-disable timer (placeholder)
- ✅ AppleScript support foundation
- ✅ Device removal callback structure
- ✅ Menu item state management

### Key Features Planned

- [ ] Preferences window and settings management
- [ ] Helper process communication (XPC)
- [ ] Advanced USB device filtering
- [ ] Keyboard shortcut support
- [ ] Screen lock on device removal
- [ ] Multiple YubiKey support
- [ ] Application icon and resources

## Differences from Original Objective-C Implementation

### Language Features
- **Swift optionals** instead of nullable pointers
- **Closures** instead of target-action patterns where appropriate
- **Property observers** for state management
- **Type safety** for improved reliability

### Architecture Improvements
- **Protocol-oriented design** for better testability
- **Clear separation of concerns** between UI and device management
- **Modern completion handlers** for asynchronous operations
- **Swift-native error handling** with Result types

### AppKit Integration
- Uses modern `NSStatusItem` API
- Leverages `UserNotifications` framework
- Implements Swift-native menu management
- Uses `Timer` with closure-based callbacks

## Current Implementation Status

This is a **scaffolding implementation** with placeholder logic for USB detection and device control. The core architecture is established, but the following components need full implementation:

### USB Device Control
The current implementation includes IOKit HID framework integration but requires:
- Proper device enumeration and filtering
- XPC communication with privileged helper process
- Advanced error handling and recovery
- Multiple device support

### Helper Process
The original app requires a privileged helper process for exclusive USB device access. The Swift rewrite will need:
- Swift-based helper process or compatibility with existing C helper
- XPC service communication
- Proper privilege escalation handling
- Security and sandboxing considerations

### User Interface
Basic menu structure is implemented, but needs:
- Preferences window with device configuration
- About window with application information
- Custom application icons
- Accessibility support

## Building and Running

### Prerequisites
- macOS 10.14 or later
- Xcode with Swift 6.2 support
- IOKit framework access

### Build Instructions
```bash
cd YubiSwitchSwift
swift build -c release
./.build/release/YubiSwitchSwift
```

### Development Notes
- The app requires macOS-specific frameworks (AppKit, IOKit)
- USB device access requires appropriate entitlements
- Helper process installation requires administrator privileges

## Integration with Original Project

This Swift rewrite maintains compatibility with the original project structure:
- Uses same application bundle identifier concepts
- Maintains AppleScript command compatibility (KeyOn/KeyOff)
- Preserves user preferences format and location
- Compatible with existing helper process (with adaptation layer)

## Next Steps

1. **Complete USB device management** - Implement full IOKit HID integration
2. **Add helper process communication** - XPC service integration
3. **Create preferences UI** - SwiftUI or AppKit-based settings window
4. **Add application resources** - Icons, strings, entitlements
5. **Implement advanced features** - Keyboard shortcuts, multiple device support
6. **Add comprehensive testing** - Unit tests and integration tests
7. **Create deployment package** - Bundle and code signing

## File Structure

```
YubiSwitchSwift/
├── Package.swift                 # Swift Package Manager configuration
├── Sources/YubiSwitchSwift/
│   ├── YubiSwitchSwift.swift    # Main entry point
│   ├── AppDelegate.swift        # Application controller
│   └── YubiKey.swift           # USB device management
├── Resources/                    # (To be added) Icons and assets
└── README.md                    # This file
```

This Swift implementation provides a modern, maintainable foundation for the YubiSwitch application while preserving the core functionality and user experience of the original Objective-C version.