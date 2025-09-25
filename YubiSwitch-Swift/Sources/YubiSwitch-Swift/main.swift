/*
 YubiSwitch-Swift - enable/disable yubikey (Swift Port)
 
 This is a Swift port of the original yubiswitch application by Angelo "pallotron" Failla.
 Original Copyright (C) 2013-2015 Angelo "pallotron" Failla <pallotron@freaknet.org>
 Swift Port Copyright (C) 2024
 
 This program is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.
 
 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 GNU General Public License for more details.
 
 You should have received a copy of the GNU General Public License
 along with this program. If not, see <http://www.gnu.org/licenses/>.
 */

#if canImport(AppKit)
import AppKit
import UserNotifications

// Main application entry point
let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate
app.run()

#else
// Fallback for non-macOS platforms
import Foundation

print("YubiSwitch-Swift is designed for macOS only")
print("This application requires AppKit and IOKit frameworks")
exit(1)
#endif