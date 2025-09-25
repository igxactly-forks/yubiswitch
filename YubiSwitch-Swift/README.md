# YubiSwitch-Swift

A modern Swift port of the original yubiswitch macOS status bar application. This application allows you to enable or disable your YubiKey Nano/Neo to prevent accidental OTP generation.

## Overview

YubiSwitch-Swift replicates the core functionality of the original Objective-C yubiswitch application but reimagined in modern Swift with SwiftUI/AppKit. The application provides a convenient status bar interface for controlling your YubiKey device.

### Key Features

- **Status Bar Interface**: Clean, modern status bar application with intuitive menu items
- **YubiKey Control**: Enable/disable YubiKey Nano/Neo devices
- **System Notifications**: Native macOS notifications for state changes
- **Modern Swift Architecture**: Clean separation of concerns with proper Swift patterns
- **Extensible Design**: Scaffolded for future expansion and feature additions

## Architecture

The application is structured with clear separation of concerns:

```
YubiSwitch-Swift/
├── Sources/
│   ├── YubiSwitch-Swift/
│   │   ├── main.swift                    # Application entry point
│   │   ├── AppDelegate.swift             # Main app delegate and status bar
│   │   ├── UI/
│   │   │   └── PreferencesView.swift     # SwiftUI preferences interface
│   │   ├── DeviceManagement/
│   │   │   ├── YubiKeyManager.swift      # Core device management
│   │   │   └── YubiKeyBridge.swift       # C API integration bridge
│   │   └── Utilities/
│   │       ├── NotificationManager.swift # System notifications
│   │       └── PreferencesManager.swift  # Settings persistence
│   └── Resources/                        # App resources (icons, etc.)
└── Tests/                               # Unit tests
```

### Core Components

#### AppDelegate
- Manages status bar item and menu
- Handles user interactions
- Coordinates between managers
- Provides main application lifecycle

#### YubiKeyManager
- Core device management functionality
- Communicates with YubiKey devices
- Manages device state
- Provides async interface for device operations

#### YubiKeyBridge
- Bridge for C API integration
- XPC communication with helper daemon
- Direct USB/HID interface (future)
- Service management integration

#### NotificationManager
- System notification handling
- User feedback management
- Alert dialogs

#### PreferencesManager
- Application settings persistence
- Configuration validation
- Default values management

## Current Implementation Status

### ✅ Implemented
- [x] Swift application structure
- [x] Status bar interface with menu
- [x] Basic YubiKey enable/disable interface
- [x] System notifications
- [x] Preferences management structure
- [x] SwiftUI preferences view (placeholder)
- [x] Clean architecture with separation of concerns
- [x] Comprehensive documentation
- [x] Error handling framework

### 🚧 Placeholder Implementation
- [ ] **Direct YubiKey Communication**: Current implementation uses placeholder logic
- [ ] **Privileged Helper Daemon**: XPC communication not yet implemented
- [ ] **USB HID Interface**: Direct hardware access needs C API bridging
- [ ] **Device Detection**: Automatic YubiKey device discovery
- [ ] **Helper Installation**: Service Management integration

### 🔮 Future Enhancements
- [ ] Full preferences window with SwiftUI
- [ ] Hotkey support for quick toggle
- [ ] AppleScript support
- [ ] Multiple YubiKey support
- [ ] Auto-disable timer functionality
- [ ] Login item management
- [ ] Lock screen on device disconnect
- [ ] Advanced device configuration

## Building and Running

### Prerequisites
- macOS 13.0 or later
- Xcode 15.0 or later
- Swift 5.9 or later

### Building with Swift Package Manager

```bash
cd YubiSwitch-Swift
swift build
```

### Running the Application

```bash
swift run YubiSwitch-Swift
```

### Creating Xcode Project (Alternative)

For full Xcode integration, you can generate an Xcode project:

```bash
swift package generate-xcodeproj
```

## Current Functionality

The current implementation provides:

1. **Status Bar Application**: Appears in macOS status bar with YubiKey icon
2. **Menu Interface**: Click to access enable/disable options
3. **State Management**: Tracks and displays current YubiKey state
4. **Notifications**: System notifications for state changes
5. **About Dialog**: Application information
6. **Placeholder Preferences**: Framework for future settings

### Menu Items

- **Enable/Disable YubiKey**: Toggle YubiKey state
- **About YubiSwitch-Swift**: Application information
- **Preferences**: Settings (placeholder)
- **Quit**: Exit application

## Development Notes

### Hardware Interaction

The current implementation includes placeholder logic for YubiKey interaction. To implement full functionality, the following components need to be developed:

1. **Privileged Helper Daemon**
   - XPC service for privileged operations
   - USB HID device control
   - Service Management integration

2. **C API Bridging**
   - IOKit integration for USB device access
   - HID interface management
   - Device enumeration and monitoring

3. **Security Framework**
   - Authorization for privileged operations
   - Helper daemon installation and management
   - Secure communication channels

### Testing

Currently implemented as a minimal status bar application with:
- Simulated YubiKey operations
- Full UI interaction
- Notification system
- State management

## Extending the Application

The architecture is designed for easy extension:

### Adding New Device Types

1. Extend `YubiKeyConfiguration` with new device parameters
2. Update `YubiKeyManager` device detection logic
3. Add device-specific handling in `YubiKeyBridge`

### Adding New Features

1. **UI Features**: Add to SwiftUI views in `UI/` folder
2. **Device Features**: Extend `YubiKeyManager` and related classes
3. **System Integration**: Add utilities to `Utilities/` folder

### Implementing Hardware Access

1. **XPC Service**: Implement privileged helper daemon
2. **IOKit Integration**: Add C API bridging code
3. **Service Management**: Handle helper installation

## Original yubiswitch Compatibility

This Swift port maintains compatibility with the original yubiswitch concepts:

- Same core functionality (enable/disable YubiKey)
- Similar menu structure and user experience
- Compatible device support (Nano/Neo)
- Notification system
- Future AppleScript support planned

## Contributing

When contributing to this project:

1. Maintain the clean architecture patterns
2. Add comprehensive documentation for new features
3. Include placeholder implementations where hardware access is not available
4. Follow Swift best practices and conventions
5. Update this README with new functionality

## License

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

## Acknowledgments

- Original yubiswitch by Angelo "pallotron" Failla
- Yubico for YubiKey hardware
- macOS development community for guidance and examples

---

**Note**: This is an initial implementation focusing on application structure and UI. Full YubiKey hardware interaction requires additional development of privileged helper daemon and C API integration components.