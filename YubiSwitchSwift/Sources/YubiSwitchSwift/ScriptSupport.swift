/*
 yubiswitch - Swift rewrite
 Copyright (C) 2024 Swift Port
 
 AppleScript Support
 */

#if canImport(AppKit)
import Foundation
import AppKit

class YubiKeyScriptCommand: NSScriptCommand {
    override func performDefaultImplementation() -> Any? {
        guard let appDelegate = NSApplication.shared.delegate as? AppDelegate else {
            return nil
        }
        
        guard let commandName = commandDescription?.commandName else {
            return nil
        }
        
        switch commandName {
        case "KeyOn":
            appDelegate.enableYubiKey()
            return nil
        case "KeyOff":
            appDelegate.disableYubiKey()
            return nil
        default:
            return nil
        }
    }
}
#endif