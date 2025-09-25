# YubiSwitch Swift Implementation Notes

## Code Architecture Comparison

### Original Objective-C Structure
```objc
// AppDelegate.m - Status bar management and main app logic
@implementation AppDelegate
- (void)awakeFromNib {
    statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    [statusItem setMenu:statusMenu];
}
- (IBAction)toggle:(id)sender {
    [self enableYubiKey:!isEnabled];
}
@end

// YubiKey.m - USB device control via XPC to helper
@implementation YubiKey
- (BOOL)action:(NSString *)action {
    xpc_connection_t connection = xpc_connection_create_mach_service("com.pallotron.yubiswitch.helper", ...);
    // XPC communication with privileged helper
}
@end
```

### New Swift Structure
```swift
// AppDelegate.swift - Modern Swift with closures and optionals
class AppDelegate: NSObject, NSApplicationDelegate {
    private var statusItem: NSStatusItem?
    private var isEnabled: Bool = false
    
    private func setupStatusBar() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        // Modern closure-based timer
        stateTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateMenuState()
        }
    }
    
    @objc private func toggle() {
        let newState = !isEnabled
        let success = newState ? yubiKey.enable() : yubiKey.disable()
        // Swift-native error handling and state management
    }
}

// YubiKey.swift - Direct IOKit integration with Swift types
class YubiKey {
    private var deviceManager: IOHIDManager?
    private var hidDevice: IOHIDDevice?
    
    func enable() -> Bool {
        // Direct IOKit calls with proper Swift error handling
        guard let device = hidDevice else { return true }
        let result = IOHIDDeviceClose(device, IOHIDOptionsType(kIOHIDOptionsTypeSeizeDevice))
        return result == kIOReturnSuccess
    }
}
```

## Key Improvements in Swift Version

### Type Safety
- **Optional types** eliminate null pointer crashes
- **Enum states** replace magic numbers
- **Result types** for better error handling

### Memory Management
- **Automatic Reference Counting (ARC)** eliminates manual memory management
- **Weak references** prevent retain cycles
- **defer blocks** ensure cleanup

### Modern Patterns
- **Closure-based callbacks** instead of target-action
- **Property observers** for state changes
- **Protocol conformance** for better architecture

### Error Handling
```swift
// Instead of Objective-C NSError patterns:
enum YubiKeyError: Error {
    case deviceNotFound
    case operationFailed(IOReturn)
    case helperCommunicationFailed
}

func enable() throws {
    guard let device = findDevice() else {
        throw YubiKeyError.deviceNotFound
    }
    // Operation with proper error propagation
}
```

## Implementation Stages

### Stage 1: Basic Architecture ✅
- [x] Swift Package Manager project
- [x] AppDelegate with status bar
- [x] YubiKey class structure
- [x] Basic menu and notifications
- [x] Cross-platform demo version

### Stage 2: Core Functionality
- [ ] Complete IOKit HID integration
- [ ] Device detection and enumeration
- [ ] State management and persistence
- [ ] User preferences system

### Stage 3: Helper Process Integration
- [ ] XPC service communication
- [ ] Privilege escalation handling
- [ ] Security framework integration
- [ ] Helper process lifecycle management

### Stage 4: Advanced Features
- [ ] SwiftUI preferences window
- [ ] Keyboard shortcuts with Carbon/HID
- [ ] Multiple device support
- [ ] AppleScript automation support

### Stage 5: Polish and Distribution
- [ ] App bundle and resources
- [ ] Code signing and notarization
- [ ] Accessibility support
- [ ] Localization framework

## Technical Considerations

### IOKit Integration
The Swift version directly interfaces with IOKit HID framework:
```swift
private func setupDeviceManager() {
    deviceManager = IOHIDManagerCreate(kCFAllocatorDefault, IOHIDOptionsType(kIOHIDOptionsTypeNone))
    
    let matchingDict = createMatchingDictionary(vendorID: vendorID, productID: productID)
    IOHIDManagerSetDeviceMatching(manager, matchingDict)
    
    // Modern closure-based callbacks
    let context = Unmanaged.passUnretained(self).toOpaque()
    IOHIDManagerRegisterDeviceMatchingCallback(manager, deviceMatchingCallback, context)
}
```

### XPC Communication
For privileged operations, the Swift app can:
1. **Reuse existing C helper** with Swift wrapper
2. **Create new Swift helper** with XPC service framework
3. **Use NSXPCConnection** for type-safe IPC

### User Interface
Modern AppKit integration:
```swift
// Status bar with SF Symbols
button.image = NSImage(systemSymbolName: "lock.circle.fill", accessibilityDescription: "YubiKey")

// UserNotifications framework
let content = UNMutableNotificationContent()
content.title = "YubiKey enabled"
UNUserNotificationCenter.current().add(request)
```

This Swift implementation provides a clean, modern foundation while maintaining compatibility with the original app's functionality and user experience.