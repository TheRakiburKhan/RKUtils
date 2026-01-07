// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "RKUtils",
    platforms: [.iOS(.v14), .macOS(.v11), .watchOS(.v7), .tvOS(.v14), .visionOS(.v1), .macCatalyst(.v14)],
    products: [
        // Single unified library with all utilities
        .library(
            name: "RKUtils",
            targets: ["RKUtils"]),
    ],
    dependencies: [
        // No external dependencies
    ],
    targets: [
        // Single target with all utilities (Foundation, UIKit, AppKit, SwiftUI)
        // Platform-specific code is handled via conditional compilation (#if canImport)
        .target(name: "RKUtils"),

        // Single test target
        .testTarget(
            name: "RKUtilsTests",
            dependencies: ["RKUtils"]
        ),
    ]
)
