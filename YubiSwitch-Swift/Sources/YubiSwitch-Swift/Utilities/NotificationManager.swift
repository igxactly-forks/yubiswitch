/*
 YubiSwitch-Swift - enable/disable yubikey (Swift Port)
 
 NotificationManager - Handles user notifications and alerts
 
 This utility class provides a clean interface for sending system notifications
 and managing user feedback throughout the application.
 */

import Foundation

#if canImport(UserNotifications)
import UserNotifications
#endif

#if canImport(AppKit)
import AppKit
#endif

enum AlertStyle {
    case informational
    case warning
    case critical
    
    #if canImport(AppKit)
    var nsAlertStyle: NSAlert.Style {
        switch self {
        case .informational: return .informational
        case .warning: return .warning
        case .critical: return .critical
        }
    }
    #endif
}

class NotificationManager {
    static let shared = NotificationManager()
    
    private init() {
        requestNotificationPermission()
    }
    
    // MARK: - Permission Management
    private func requestNotificationPermission() {
        #if canImport(UserNotifications)
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("[NotificationManager] Notification permission granted")
            } else if let error = error {
                print("[NotificationManager] Notification permission denied: \(error)")
            }
        }
        #else
        print("[NotificationManager] UserNotifications framework not available")
        #endif
    }
    
    // MARK: - Notification Methods
    func sendYubiKeyStatusNotification(isEnabled: Bool) {
        let message = isEnabled ? "YubiKey enabled" : "YubiKey disabled"
        sendNotification(title: "YubiSwitch-Swift", message: message)
    }
    
    func sendErrorNotification(_ error: YubiKeyError) {
        sendNotification(title: "YubiSwitch-Swift Error", message: error.localizedDescription)
    }
    
    func sendNotification(title: String, message: String) {
        #if canImport(UserNotifications)
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = message
        content.sound = .default
        
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: nil
        )
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("[NotificationManager] Failed to send notification: \(error)")
            }
        }
        #else
        print("[NotificationManager] Notification: \(title) - \(message)")
        #endif
    }
    
    // MARK: - Alert Methods
    func showAlert(title: String, message: String, style: AlertStyle = .informational) {
        #if canImport(AppKit)
        DispatchQueue.main.async {
            let alert = NSAlert()
            alert.messageText = title
            alert.informativeText = message
            alert.alertStyle = style.nsAlertStyle
            alert.addButton(withTitle: "OK")
            alert.runModal()
        }
        #else
        print("[NotificationManager] Alert: \(title) - \(message)")
        #endif
    }
    
    func showErrorAlert(_ error: YubiKeyError) {
        showAlert(
            title: "YubiKey Error",
            message: error.localizedDescription,
            style: .critical
        )
    }
}