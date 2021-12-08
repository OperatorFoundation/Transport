// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Transport",
    platforms: [
        .macOS(.v10_15),
    ],
    products: [
        .library(
            name: "Transport",
            targets: ["Transport"]),
    ],
    dependencies: [
        .package(url: "https://github.com/OperatorFoundation/Datable.git", from: "3.1.5"),
        .package(url: "https://github.com/OperatorFoundation/Net.git", from: "0.0.7"),
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
