/*
 YubiSwitch-Swift - enable/disable yubikey (Swift Port)
 
 PreferencesManager - Handles application preferences and settings
 
 This utility class manages application preferences, settings persistence,
 and configuration management for the YubiSwitch application.
 */

import Foundation

class PreferencesManager {
    static let shared = PreferencesManager()
    
    private let userDefaults = UserDefaults.standard
    
    private init() {
        registerDefaultValues()
    }
    
    // MARK: - Keys
    private enum Keys {
        static let yubiKeyVendorID = "yubiKeyVendorID"
        static let yubiKeyProductID = "yubiKeyProductID"
        static let enableNotifications = "enableNotifications"
        static let autoDisableDelay = "autoDisableDelay"
        static let lockOnDisconnect = "lockOnDisconnect"
        static let startAtLogin = "startAtLogin"
    }
    
    // MARK: - Default Values
    private func registerDefaultValues() {
        let defaultValues: [String: Any] = [
            Keys.yubiKeyVendorID: "1050",    // Yubico vendor ID in hex
            Keys.yubiKeyProductID: "0116",   // YubiKey Nano product ID in hex
            Keys.enableNotifications: true,
            Keys.autoDisableDelay: 0,        // 0 means disabled
            Keys.lockOnDisconnect: false,
            Keys.startAtLogin: false
        ]
        
        userDefaults.register(defaults: defaultValues)
    }
    
    // MARK: - YubiKey Configuration
    var yubiKeyVendorID: String {
        get { userDefaults.string(forKey: Keys.yubiKeyVendorID) ?? "1050" }
        set { userDefaults.set(newValue, forKey: Keys.yubiKeyVendorID) }
    }
    
    var yubiKeyProductID: String {
        get { userDefaults.string(forKey: Keys.yubiKeyProductID) ?? "0116" }
        set { userDefaults.set(newValue, forKey: Keys.yubiKeyProductID) }
    }
    
    var yubiKeyConfiguration: YubiKeyConfiguration {
        let vendorID = UInt16(yubiKeyVendorID, radix: 16) ?? 0x1050
        let productID = UInt16(yubiKeyProductID, radix: 16) ?? 0x0116
        
        return YubiKeyConfiguration(
            vendorID: vendorID,
            productID: productID,
            usagePage: 0x01,
            usage: 0x06
        )
    }
    
    // MARK: - Notification Settings
    var enableNotifications: Bool {
        get { userDefaults.bool(forKey: Keys.enableNotifications) }
        set { userDefaults.set(newValue, forKey: Keys.enableNotifications) }
    }
    
    // MARK: - Auto-disable Settings
    var autoDisableDelay: Int {
        get { userDefaults.integer(forKey: Keys.autoDisableDelay) }
        set { userDefaults.set(newValue, forKey: Keys.autoDisableDelay) }
    }
    
    var isAutoDisableEnabled: Bool {
        return autoDisableDelay > 0
    }
    
    // MARK: - Security Settings
    var lockOnDisconnect: Bool {
        get { userDefaults.bool(forKey: Keys.lockOnDisconnect) }
        set { userDefaults.set(newValue, forKey: Keys.lockOnDisconnect) }
    }
    
    // MARK: - Startup Settings
    var startAtLogin: Bool {
        get { userDefaults.bool(forKey: Keys.startAtLogin) }
        set { 
            userDefaults.set(newValue, forKey: Keys.startAtLogin)
            configureLoginItem(enabled: newValue)
        }
    }
    
    // MARK: - Login Item Configuration
    private func configureLoginItem(enabled: Bool) {
        // TODO: Implement login item configuration
        // This would involve adding/removing the app from login items
        print("[PreferencesManager] Configure login item: \(enabled) (placeholder)")
    }
    
    // MARK: - Preference Validation
    func validatePreferences() -> [String] {
        var errors: [String] = []
        
        // Validate vendor ID
        if UInt16(yubiKeyVendorID, radix: 16) == nil {
            errors.append("Invalid vendor ID format")
        }
        
        // Validate product ID
        if UInt16(yubiKeyProductID, radix: 16) == nil {
            errors.append("Invalid product ID format")
        }
        
        // Validate auto-disable delay
        if autoDisableDelay < 0 {
            errors.append("Auto-disable delay cannot be negative")
        }
        
        return errors
    }
    
    // MARK: - Reset to Defaults
    func resetToDefaults() {
        let keys = [
            Keys.yubiKeyVendorID,
            Keys.yubiKeyProductID,
            Keys.enableNotifications,
            Keys.autoDisableDelay,
            Keys.lockOnDisconnect,
            Keys.startAtLogin
        ]
        
        keys.forEach { userDefaults.removeObject(forKey: $0) }
        registerDefaultValues()
        
        print("[PreferencesManager] Reset to default values")
    }
}