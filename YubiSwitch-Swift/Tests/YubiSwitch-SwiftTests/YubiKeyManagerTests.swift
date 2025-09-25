/*
 YubiSwitch-Swift - enable/disable yubikey (Swift Port)
 
 Unit tests for YubiKeyManager
 */

import XCTest
@testable import YubiSwitch_Swift

final class YubiKeyManagerTests: XCTestCase {
    var yubiKeyManager: YubiKeyManager!
    
    override func setUp() {
        super.setUp()
        yubiKeyManager = YubiKeyManager()
    }
    
    override func tearDown() {
        yubiKeyManager.cleanup()
        yubiKeyManager = nil
        super.tearDown()
    }
    
    func testInitialization() {
        XCTAssertNotNil(yubiKeyManager)
        XCTAssertFalse(yubiKeyManager.getCurrentState())
    }
    
    func testEnableYubiKey() {
        let expectation = self.expectation(description: "YubiKey enabled")
        
        yubiKeyManager.enableYubiKey { success in
            XCTAssertTrue(success)
            XCTAssertTrue(self.yubiKeyManager.getCurrentState())
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2.0, handler: nil)
    }
    
    func testDisableYubiKey() {
        let expectation = self.expectation(description: "YubiKey disabled")
        
        // First enable
        yubiKeyManager.enableYubiKey { _ in
            // Then disable
            self.yubiKeyManager.disableYubiKey { success in
                XCTAssertTrue(success)
                XCTAssertFalse(self.yubiKeyManager.getCurrentState())
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 3.0, handler: nil)
    }
}