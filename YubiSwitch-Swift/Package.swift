// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "YubiSwitch-Swift",
    platforms: [.macOS(.v13)],
    products: [
        .executable(
            name: "YubiSwitch-Swift",
            targets: ["YubiSwitch-Swift"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
    ],
    targets: [
        .executableTarget(
            name: "YubiSwitch-Swift",
            dependencies: [],
            path: "Sources",
            resources: [
                .process("Resources")
            ]
        ),
        .testTarget(
            name: "YubiSwitch-SwiftTests",
            dependencies: ["YubiSwitch-Swift"],
            path: "Tests"
        ),
    ]
)