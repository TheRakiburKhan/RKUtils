// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "RKUtils",
    platforms: [.iOS(.v13), .macOS(.v10_15), .watchOS(.v6), .tvOS(.v13), .visionOS(.v1), .macCatalyst(.v13)],
    products: [
        // Cross-platform utilities (String, Date, Int, Double, Bundle, CLLocationCoordinate2D, Data)
        .library(
            name: "RKUtils",
            targets: ["RKUtils"]),

        // UIKit platforms (iOS, tvOS, visionOS, Catalyst) - includes UIView, UIColor, etc.
        .library(
            name: "RKUtilsUI",
            targets: ["RKUtils", "RKUtilsUI", "RKUtilsSwiftUI"]),

        // AppKit platform (macOS) - includes NSView, NSColor, etc.
        .library(
            name: "RKUtilsMacOS",
            targets: ["RKUtils", "RKUtilsMacOSUI", "RKUtilsSwiftUI"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
    ],
    targets: [
        // Cross-platform target (works on all platforms)
        .target(name: "RKUtils"),

        // UIKit-specific utilities (iOS, tvOS, visionOS, Catalyst)
        .target(
            name: "RKUtilsUI",
            dependencies: ["RKUtils"],
            swiftSettings: [
                .define("UIKIT_AVAILABLE", .when(platforms: [.iOS, .tvOS, .visionOS, .macCatalyst]))
            ]
        ),

        // AppKit-specific utilities (macOS)
        .target(
            name: "RKUtilsMacOSUI",
            dependencies: ["RKUtils"],
            swiftSettings: [
                .define("APPKIT_AVAILABLE", .when(platforms: [.macOS]))
            ]
        ),

        // SwiftUI-specific utilities (Apple platforms only - SwiftUI not available on Linux/Windows)
        .target(
            name: "RKUtilsSwiftUI",
            dependencies: ["RKUtils"],
            swiftSettings: [
                .define("SWIFTUI_AVAILABLE", .when(platforms: [.iOS, .macOS, .watchOS, .tvOS, .visionOS, .macCatalyst]))
            ]
        ),

        // Tests
        .testTarget(
            name: "RKUtilsTests",
            dependencies: ["RKUtils"]
        ),
        .testTarget(
            name: "RKUtilsUITests",
            dependencies: ["RKUtils", "RKUtilsUI", "RKUtilsSwiftUI"]
        ),
        .testTarget(
            name: "RKUtilsMacOSTests",
            dependencies: ["RKUtils", "RKUtilsMacOSUI"]
        ),
    ]
)
