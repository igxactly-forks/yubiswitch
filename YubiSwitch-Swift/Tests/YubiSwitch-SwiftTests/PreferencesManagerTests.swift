/*
 YubiSwitch-Swift - enable/disable yubikey (Swift Port)
 
 Unit tests for PreferencesManager
 */

import XCTest
@testable import YubiSwitch_Swift

final class PreferencesManagerTests: XCTestCase {
    var preferencesManager: PreferencesManager!
    
    override func setUp() {
        super.setUp()
        preferencesManager = PreferencesManager.shared
        // Reset to defaults for clean test state
        preferencesManager.resetToDefaults()
    }
    
    func testDefaultValues() {
        XCTAssertEqual(preferencesManager.yubiKeyVendorID, "1050")
        XCTAssertEqual(preferencesManager.yubiKeyProductID, "0116")
        XCTAssertTrue(preferencesManager.enableNotifications)
        XCTAssertEqual(preferencesManager.autoDisableDelay, 0)
        XCTAssertFalse(preferencesManager.lockOnDisconnect)
        XCTAssertFalse(preferencesManager.startAtLogin)
    }
    
    func testYubiKeyConfiguration() {
        let config = preferencesManager.yubiKeyConfiguration
        XCTAssertEqual(config.vendorID, 0x1050)
        XCTAssertEqual(config.productID, 0x0116)
        XCTAssertEqual(config.usagePage, 0x01)
        XCTAssertEqual(config.usage, 0x06)
    }
    
    func testPreferenceValidation() {
        // Test valid preferences
        let errors = preferencesManager.validatePreferences()
        XCTAssertTrue(errors.isEmpty)
        
        // Test invalid vendor ID
        preferencesManager.yubiKeyVendorID = "invalid"
        let validationErrors = preferencesManager.validatePreferences()
        XCTAssertFalse(validationErrors.isEmpty)
        XCTAssertTrue(validationErrors.contains("Invalid vendor ID format"))
    }
    
    func testAutoDisableEnabled() {
        XCTAssertFalse(preferencesManager.isAutoDisableEnabled)
        
        preferencesManager.autoDisableDelay = 30
        XCTAssertTrue(preferencesManager.isAutoDisableEnabled)
    }
}