// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "RKUtils",
    platforms: [.iOS(.v13), .macOS(.v10_15), .watchOS(.v5), .tvOS(.v13), .visionOS(.v1), .macCatalyst(.v13)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "RKUtils",
            targets: ["RKUtils"]),
        .library(
            name: "RKUtilsiOS",
            targets: ["RKUtils", "RKUtilsiOSUI"])
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(name: "RKUtils"),
        .target(
            name: "RKUtilsiOSUI",
            swiftSettings: [.define("UIKIT_AVAILABLE")]),
        .testTarget(
            name: "RKUtilsiOSTests",
            dependencies: ["RKUtils", "RKUtilsiOSUI"]),
    ]
)
