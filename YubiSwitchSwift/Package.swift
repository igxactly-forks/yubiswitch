// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "YubiSwitchSwift",
    platforms: [
        .macOS(.v10_14)
    ],
    products: [
        .executable(
            name: "YubiSwitchSwift",
            targets: ["YubiSwitchSwift"]
        )
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .executableTarget(
            name: "YubiSwitchSwift",
            linkerSettings: [
                .linkedFramework("AppKit"),
                .linkedFramework("IOKit"),
                .linkedFramework("CoreFoundation"),
                .linkedFramework("ServiceManagement"),
                .linkedFramework("Security")
            ]
        ),
    ]
)
