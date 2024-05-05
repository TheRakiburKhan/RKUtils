// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "RKiOSUtils",
    platforms: [.iOS(.v13)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "RKiOSUtils",
            targets: ["RKiOSUtils"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/airbnb/lottie-ios.git", from: Version(4,0,0))
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "RKiOSUtils",
            dependencies: [.product(name: "Lottie", package: "lottie-ios")]),
        .testTarget(
            name: "RKiOSUtilsTests",
            dependencies: ["RKiOSUtils"]),
    ]
)
