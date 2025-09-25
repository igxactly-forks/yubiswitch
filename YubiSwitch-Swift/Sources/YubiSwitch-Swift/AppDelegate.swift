/*
 YubiSwitch-Swift - enable/disable yubikey (Swift Port)
 
 AppDelegate - Main application delegate handling status bar functionality
 
 This class replicates the core functionality of the original Objective-C AppDelegate
 but reimagined in modern Swift with proper separation of concerns.
 */

#if canImport(AppKit)
import Cocoa
import UserNotifications

class AppDelegate: NSObject, NSApplicationDelegate {
    // MARK: - Properties
    private var statusItem: NSStatusItem!
    private var statusBarMenu: NSMenu!
    private var yubiKeyManager: YubiKeyManager!
    private var preferencesWindowController: PreferencesWindowController?
    private var isYubiKeyEnabled: Bool = false {
        didSet {
            updateStatusBarAppearance()
        }
    }
    
    // MARK: - Application Lifecycle
    func applicationDidFinishLaunching(_ notification: Notification) {
        setupStatusBar()
        setupYubiKeyManager()
        setupNotifications()
        
        // Initialize with disabled state
        isYubiKeyEnabled = false
        sendNotification("YubiKey disabled")
        
        print("YubiSwitch-Swift started successfully")
    }
    
    func applicationWillTerminate(_ notification: Notification) {
        cleanup()
    }
    
    // MARK: - Status Bar Setup
    private func setupStatusBar() {
        // Create status item
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        guard let statusButton = statusItem.button else {
            fatalError("Could not create status bar button")
        }
        
        // Set initial icon and tooltip
        statusButton.image = NSImage(systemSymbolName: "key.slash", accessibilityDescription: "YubiKey Disabled")
        statusButton.toolTip = "YubiKey disabled"
        
        // Create menu
        statusBarMenu = NSMenu()
        setupMenu()
        statusItem.menu = statusBarMenu
    }
    
    private func setupMenu() {
        statusBarMenu.removeAllItems()
        
        // Toggle menu item
        let toggleTitle = isYubiKeyEnabled ? "Disable YubiKey" : "Enable YubiKey"
        let toggleItem = NSMenuItem(title: toggleTitle, action: #selector(toggleYubiKey), keyEquivalent: "")
        toggleItem.target = self
        statusBarMenu.addItem(toggleItem)
        
        statusBarMenu.addItem(NSMenuItem.separator())
        
        // About menu item
        let aboutItem = NSMenuItem(title: "About YubiSwitch-Swift", action: #selector(showAbout), keyEquivalent: "")
        aboutItem.target = self
        statusBarMenu.addItem(aboutItem)
        
        // Preferences menu item (placeholder for future implementation)
        let preferencesItem = NSMenuItem(title: "Preferences...", action: #selector(showPreferences), keyEquivalent: ",")
        preferencesItem.target = self
        statusBarMenu.addItem(preferencesItem)
        
        statusBarMenu.addItem(NSMenuItem.separator())
        
        // Quit menu item
        let quitItem = NSMenuItem(title: "Quit YubiSwitch-Swift", action: #selector(quitApplication), keyEquivalent: "q")
        quitItem.target = self
        statusBarMenu.addItem(quitItem)
    }
    
    private func updateStatusBarAppearance() {
        guard let statusButton = statusItem.button else { return }
        
        if isYubiKeyEnabled {
            statusButton.image = NSImage(systemSymbolName: "key", accessibilityDescription: "YubiKey Enabled")
            statusButton.toolTip = "YubiKey enabled"
        } else {
            statusButton.image = NSImage(systemSymbolName: "key.slash", accessibilityDescription: "YubiKey Disabled")
            statusButton.toolTip = "YubiKey disabled"
        }
        
        // Update menu
        setupMenu()
    }
    
    // MARK: - YubiKey Manager Setup
    private func setupYubiKeyManager() {
        yubiKeyManager = YubiKeyManager()
        yubiKeyManager.delegate = self
    }
    
    // MARK: - Notifications Setup
    private func setupNotifications() {
        // Request notification permission
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { granted, error in
            if let error = error {
                print("Failed to request notification permission: \(error)")
            }
        }
    }
    
    // MARK: - Menu Actions
    @objc private func toggleYubiKey() {
        if isYubiKeyEnabled {
            disableYubiKey()
        } else {
            enableYubiKey()
        }
    }
    
    @objc private func showAbout() {
        let alert = NSAlert()
        alert.messageText = "YubiSwitch-Swift"
        alert.informativeText = """
        A Swift port of the original yubiswitch application.
        
        This application allows you to enable or disable your YubiKey Nano/Neo to prevent accidental OTP generation.
        
        Original concept by Angelo "pallotron" Failla
        Swift port implementation for modern macOS
        """
        alert.alertStyle = .informational
        alert.addButton(withTitle: "OK")
        alert.runModal()
    }
    
    @objc private func showPreferences() {
        if preferencesWindowController == nil {
            preferencesWindowController = PreferencesWindowController()
        }
        preferencesWindowController?.showWindow(self)
    }
    
    @objc private func quitApplication() {
        NSApplication.shared.terminate(nil)
    }
    
    // MARK: - YubiKey Control
    private func enableYubiKey() {
        print("Attempting to enable YubiKey...")
        yubiKeyManager.enableYubiKey { [weak self] success in
            DispatchQueue.main.async {
                if success {
                    self?.isYubiKeyEnabled = true
                    self?.sendNotification("YubiKey enabled")
                } else {
                    self?.sendNotification("Failed to enable YubiKey")
                }
            }
        }
    }
    
    private func disableYubiKey() {
        print("Attempting to disable YubiKey...")
        yubiKeyManager.disableYubiKey { [weak self] success in
            DispatchQueue.main.async {
                if success {
                    self?.isYubiKeyEnabled = false
                    self?.sendNotification("YubiKey disabled")
                } else {
                    self?.sendNotification("Failed to disable YubiKey")
                }
            }
        }
    }
    
    // MARK: - Notifications
    private func sendNotification(_ message: String) {
        let content = UNMutableNotificationContent()
        content.title = "YubiSwitch-Swift"
        content.body = message
        content.sound = .default
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Failed to send notification: \(error)")
            }
        }
        
        print("Notification: \(message)")
    }
    
    // MARK: - Cleanup
    private func cleanup() {
        yubiKeyManager?.cleanup()
        print("YubiSwitch-Swift terminated")
    }
}

// MARK: - YubiKeyManagerDelegate
extension AppDelegate: YubiKeyManagerDelegate {
    func yubiKeyStateChanged(isEnabled: Bool) {
        DispatchQueue.main.async { [weak self] in
            self?.isYubiKeyEnabled = isEnabled
        }
    }
    
    func yubiKeyError(_ error: YubiKeyError) {
        DispatchQueue.main.async { [weak self] in
            let message = "YubiKey error: \(error.localizedDescription)"
            self?.sendNotification(message)
            print(message)
        }
    }
}

#else
// Fallback for non-macOS platforms  
class AppDelegate {
    func applicationDidFinishLaunching(_ notification: Any) {
        print("YubiSwitch-Swift requires macOS")
    }
}
#endif