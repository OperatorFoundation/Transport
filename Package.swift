// swift-tools-version:5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Transport",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "Transport",
            targets: ["Transport"]),
    ],
    dependencies: [
        .package(url: "https://github.com/OperatorFoundation/Datable.git", branch: "main"),
        .package(url: "https://github.com/OperatorFoundation/Net.git", branch: "main"),
    ],
    targets: [
        .target(
            name: "Transport",
            dependencies: ["Net"]),
        .testTarget(
            name: "TransportTests",
            dependencies: ["Transport", "Datable"]),
    ],
    swiftLanguageVersions: [.v5]
)
