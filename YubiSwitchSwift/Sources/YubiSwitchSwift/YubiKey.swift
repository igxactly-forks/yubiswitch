/*
 yubiswitch - Swift rewrite
 Copyright (C) 2024 Swift Port
 
 This program is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.
 
 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.
 
 You should have received a copy of the GNU General Public License
 along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

#if canImport(IOKit)
import Foundation
import IOKit
import IOKit.hid

class YubiKey {
    private var isEnabled: Bool = false
    private var deviceManager: IOHIDManager?
    private var hidDevice: IOHIDDevice?
    
    // Default YubiKey Nano VID/PID - would be configurable in preferences
    private var vendorID: UInt32 = 0x1050
    private var productID: UInt32 = 0x0116
    
    init() {
        setupDeviceManager()
        registerDeviceRemovalCallback()
    }
    
    deinit {
        cleanup()
    }
    
    // MARK: - Public Interface
    
    func enable() -> Bool {
        print("YubiKey: Attempting to enable")
        // In the real implementation, this would communicate with the helper process
        // to release the USB HID device from exclusive access
        
        // Placeholder implementation
        if hidDevice != nil {
            let result = IOHIDDeviceClose(hidDevice!, IOHIDOptionsType(kIOHIDOptionsTypeSeizeDevice))
            if result == kIOReturnSuccess {
                hidDevice = nil
                isEnabled = true
                print("YubiKey: Enabled successfully")
                return true
            } else {
                print("YubiKey: Failed to enable - IOHIDDeviceClose failed")
                return false
            }
        }
        
        // If no device is currently seized, consider it enabled
        isEnabled = true
        print("YubiKey: Enabled (no device currently seized)")
        return true
    }
    
    func disable() -> Bool {
        print("YubiKey: Attempting to disable")
        // In the real implementation, this would communicate with the helper process
        // to exclusively grab the USB HID device
        
        // Placeholder implementation using IOKit HID
        return disableUsingIOKit()
    }
    
    func getState() -> Bool {
        // This would check if the device is currently plugged in
        // and return true if it detects removal (inverted logic from original)
        
        // Placeholder: always return false (no state change detected)
        return false
    }
    
    // MARK: - Device Management
    
    private func setupDeviceManager() {
        print("YubiKey: Setting up device manager")
        
        deviceManager = IOHIDManagerCreate(kCFAllocatorDefault, IOHIDOptionsType(kIOHIDOptionsTypeNone))
        
        guard let manager = deviceManager else {
            print("YubiKey: Failed to create HID manager")
            return
        }
        
        // Create matching dictionary for YubiKey
        let matchingDict = createMatchingDictionary(vendorID: vendorID, productID: productID)
        IOHIDManagerSetDeviceMatching(manager, matchingDict)
        
        // Schedule with run loop
        IOHIDManagerScheduleWithRunLoop(manager, CFRunLoopGetMain(), CFRunLoopMode.defaultMode.rawValue)
        
        // Set device matching callback
        let context = Unmanaged.passUnretained(self).toOpaque()
        IOHIDManagerRegisterDeviceMatchingCallback(manager, deviceMatchingCallback, context)
        IOHIDManagerRegisterDeviceRemovalCallback(manager, deviceRemovalCallback, context)
        
        // Open the manager
        let result = IOHIDManagerOpen(manager, IOHIDOptionsType(kIOHIDOptionsTypeNone))
        if result != kIOReturnSuccess {
            print("YubiKey: Failed to open HID manager")
        }
    }
    
    private func createMatchingDictionary(vendorID: UInt32, productID: UInt32) -> CFDictionary {
        let dict = NSMutableDictionary()
        dict[kIOHIDVendorIDKey] = NSNumber(value: vendorID)
        dict[kIOHIDProductIDKey] = NSNumber(value: productID)
        dict[kIOHIDDeviceUsagePageKey] = NSNumber(value: 1)  // Generic Desktop
        dict[kIOHIDDeviceUsageKey] = NSNumber(value: 6)     // Keyboard
        return dict
    }
    
    private func disableUsingIOKit() -> Bool {
        guard let manager = deviceManager else {
            print("YubiKey: No device manager available")
            return false
        }
        
        // Get matching devices
        let deviceSet = IOHIDManagerCopyDevices(manager)
        guard let devices = deviceSet else {
            print("YubiKey: No devices found")
            isEnabled = false
            return true  // Consider it disabled if no device found
        }
        
        let deviceArray = CFSetGetValues(devices, nil, 0)
        let count = CFSetGetCount(devices)
        
        if count > 0 {
            // Try to open the first matching device exclusively
            let devicePointer = UnsafeMutablePointer<UnsafeRawPointer?>.allocate(capacity: 1)
            defer { devicePointer.deallocate() }
            
            CFSetGetValues(devices, devicePointer)
            
            if let deviceRawPointer = devicePointer.pointee {
                let device = Unmanaged<IOHIDDevice>.fromOpaque(deviceRawPointer).takeUnretainedValue()
                let result = IOHIDDeviceOpen(device, IOHIDOptionsType(kIOHIDOptionsTypeSeizeDevice))
                
                if result == kIOReturnSuccess {
                    hidDevice = device
                    isEnabled = false
                    print("YubiKey: Disabled successfully")
                    return true
                } else {
                    print("YubiKey: Failed to disable - IOHIDDeviceOpen failed with result: \(result)")
                    return false
                }
            }
        }
        
        print("YubiKey: No matching devices found to disable")
        isEnabled = false
        return true  // Consider it disabled if no device found
    }
    
    private func registerDeviceRemovalCallback() {
        // This would set up notifications for when the YubiKey is unplugged
        // For now, this is a placeholder
        print("YubiKey: Device removal callback registered (placeholder)")
    }
    
    private func cleanup() {
        if let device = hidDevice {
            IOHIDDeviceClose(device, IOHIDOptionsType(kIOHIDOptionsTypeSeizeDevice))
            hidDevice = nil
        }
        
        if let manager = deviceManager {
            IOHIDManagerClose(manager, IOHIDOptionsType(kIOHIDOptionsTypeNone))
            deviceManager = nil
        }
    }
    
    // MARK: - Device Callbacks
    
    private func deviceMatched(_ device: IOHIDDevice) {
        print("YubiKey: Device matched")
        // This would be called when a YubiKey is plugged in
    }
    
    private func deviceRemoved(_ device: IOHIDDevice) {
        print("YubiKey: Device removed")
        // This would be called when a YubiKey is unplugged
        // Could trigger screen lock if configured
        
        if hidDevice == device {
            hidDevice = nil
            isEnabled = true  // Device removed, so it's effectively enabled (can't be seized)
        }
        
        // Placeholder for lock screen functionality
        // lockScreenIfConfigured()
    }
    
    private func lockScreenIfConfigured() {
        // This would check user preferences and lock the screen if configured
        // Placeholder implementation
        print("YubiKey: Would lock screen if configured")
        
        // Real implementation would use:
        // let script = NSAppleScript(source: "tell application \"System Events\" to tell current screen saver to start")
        // script?.executeAndReturnError(nil)
    }
}

// MARK: - IOKit Callbacks

private func deviceMatchingCallback(context: UnsafeMutableRawPointer?, result: IOReturn, sender: UnsafeMutableRawPointer?, device: IOHIDDevice) {
    let yubiKey = Unmanaged<YubiKey>.fromOpaque(context!).takeUnretainedValue()
    yubiKey.deviceMatched(device)
}

private func deviceRemovalCallback(context: UnsafeMutableRawPointer?, result: IOReturn, sender: UnsafeMutableRawPointer?, device: IOHIDDevice) {
    let yubiKey = Unmanaged<YubiKey>.fromOpaque(context!).takeUnretainedValue()
    yubiKey.deviceRemoved(device)
}
#endif