// swift-tools-version:5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Transport",
    platforms: [
        .macOS(.v13),
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "Transport",
            targets: ["Transport"]),
    ],
    dependencies: [
        .package(url: "https://github.com/OperatorFoundation/Datable", from: "4.0.1"),
        .package(url: "https://github.com/OperatorFoundation/Net", from: "0.0.10"),
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
