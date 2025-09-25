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

#if canImport(AppKit)
import AppKit
import UserNotifications

class AppDelegate: NSObject, NSApplicationDelegate {
    private var statusItem: NSStatusItem?
    private var isEnabled: Bool = false
    private var yubiKey: YubiKey?
    private var stateTimer: Timer?
    private var reDisableTimer: Timer?
    
    // MARK: - Application Lifecycle
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        setupStatusBar()
        setupYubiKey()
        setupNotifications()
        setupStateMonitoring()
        
        // Initial state - disabled
        updateUIState(enabled: false)
        notify(message: "YubiKey disabled")
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        stateTimer?.invalidate()
        reDisableTimer?.invalidate()
        yubiKey?.disable()
    }
    
    // MARK: - Status Bar Setup
    
    private func setupStatusBar() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        guard let statusItem = statusItem,
              let button = statusItem.button else {
            print("Failed to create status item")
            return
        }
        
        // Set initial image (disabled state)
        button.image = NSImage(systemSymbolName: "lock.circle.fill", accessibilityDescription: "YubiKey")
        button.toolTip = "YubiKey disabled"
        
        // Create menu
        let menu = NSMenu()
        
        // Toggle menu item
        let toggleItem = NSMenuItem(title: "Enable YubiKey", action: #selector(toggle), keyEquivalent: "")
        toggleItem.target = self
        menu.addItem(toggleItem)
        
        menu.addItem(NSMenuItem.separator())
        
        // Preferences menu item (placeholder)
        let prefsItem = NSMenuItem(title: "Preferences...", action: #selector(showPreferences), keyEquivalent: ",")
        prefsItem.target = self
        menu.addItem(prefsItem)
        
        // About menu item (placeholder)
        let aboutItem = NSMenuItem(title: "About YubiSwitch", action: #selector(showAbout), keyEquivalent: "")
        aboutItem.target = self
        menu.addItem(aboutItem)
        
        menu.addItem(NSMenuItem.separator())
        
        // Quit menu item
        let quitItem = NSMenuItem(title: "Quit YubiSwitch", action: #selector(quit), keyEquivalent: "q")
        quitItem.target = self
        menu.addItem(quitItem)
        
        statusItem.menu = menu
    }
    
    // MARK: - YubiKey Setup
    
    private func setupYubiKey() {
        yubiKey = YubiKey()
        yubiKey?.disable() // Start in disabled state
    }
    
    // MARK: - Notifications Setup
    
    private func setupNotifications() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { granted, error in
            if let error = error {
                print("Notification authorization error: \(error)")
            }
        }
    }
    
    // MARK: - State Monitoring
    
    private func setupStateMonitoring() {
        // Timer to check YubiKey state periodically
        stateTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateMenuState()
        }
    }
    
    private func updateMenuState() {
        guard let yubiKey = yubiKey else { return }
        
        // Check if YubiKey state changed
        let currentState = yubiKey.getState()
        if isEnabled && currentState {
            print("YubiKey state changed - disabling")
            updateUIState(enabled: false)
            notify(message: "YubiKey disabled")
        }
    }
    
    // MARK: - UI State Management
    
    private func updateUIState(enabled: Bool) {
        isEnabled = enabled
        
        guard let statusItem = statusItem,
              let button = statusItem.button,
              let menu = statusItem.menu else { return }
        
        // Update button image and tooltip
        if enabled {
            button.image = NSImage(systemSymbolName: "lock.open.fill", accessibilityDescription: "YubiKey Enabled")
            button.toolTip = "YubiKey enabled"
        } else {
            button.image = NSImage(systemSymbolName: "lock.circle.fill", accessibilityDescription: "YubiKey Disabled")
            button.toolTip = "YubiKey disabled"
        }
        
        // Update menu item title and state
        if let toggleItem = menu.item(at: 0) {
            toggleItem.title = enabled ? "Disable YubiKey" : "Enable YubiKey"
            toggleItem.state = enabled ? .on : .off
        }
    }
    
    // MARK: - User Notifications
    
    private func notify(message: String) {
        let content = UNMutableNotificationContent()
        content.title = message
        content.sound = UNNotificationSound.default
        
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: nil
        )
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Notification error: \(error)")
            }
        }
    }
    
    // MARK: - Menu Actions
    
    @objc private func toggle() {
        let newState = !isEnabled
        
        guard let yubiKey = yubiKey else {
            print("YubiKey not initialized")
            return
        }
        
        let success = newState ? yubiKey.enable() : yubiKey.disable()
        
        if success {
            updateUIState(enabled: newState)
            notify(message: newState ? "YubiKey enabled" : "YubiKey disabled")
            
            // If enabling, set up auto-disable timer (placeholder - would read from preferences)
            if newState {
                // Cancel any existing timer
                reDisableTimer?.invalidate()
                
                // Create new timer for 5 minutes (placeholder)
                reDisableTimer = Timer.scheduledTimer(withTimeInterval: 300.0, repeats: false) { [weak self] _ in
                    self?.autoDisable()
                }
            } else {
                reDisableTimer?.invalidate()
                reDisableTimer = nil
            }
        } else {
            print("Failed to change YubiKey state")
            notify(message: "Failed to change YubiKey state")
        }
    }
    
    private func autoDisable() {
        guard let yubiKey = yubiKey else { return }
        
        if yubiKey.disable() {
            updateUIState(enabled: false)
            notify(message: "YubiKey auto-disabled")
        }
        
        reDisableTimer = nil
    }
    
    @objc private func showPreferences() {
        // Placeholder for preferences window
        let alert = NSAlert()
        alert.messageText = "Preferences"
        alert.informativeText = "Preferences window not yet implemented in Swift rewrite"
        alert.addButton(withTitle: "OK")
        alert.runModal()
    }
    
    @objc private func showAbout() {
        // Placeholder for about window
        let alert = NSAlert()
        alert.messageText = "About YubiSwitch"
        alert.informativeText = "Swift rewrite of YubiSwitch - a macOS status bar app for enabling/disabling YubiKey devices."
        alert.addButton(withTitle: "OK")
        alert.runModal()
    }
    
    @objc private func quit() {
        NSApplication.shared.terminate(nil)
    }
}

// MARK: - AppleScript Support (Placeholder)

extension AppDelegate {
    // These methods would be called by AppleScript commands
    func enableYubiKey() {
        if !isEnabled {
            toggle()
        }
    }
    
    func disableYubiKey() {
        if isEnabled {
            toggle()
        }
    }
    
    func getStatus() -> Bool {
        return isEnabled
    }
}
#endif