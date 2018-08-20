// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Transport",
    products: [
        .library(
            name: "Network",
            targets: ["Network"]),
        .library(
            name: "Transport",
            targets: ["Transport"]),
    ],
    dependencies: [
        .package(url: "https://github.com/OperatorFoundation/Datable.git", from: "0.1.2"),
        .package(url: "https://github.com/swiftsocket/SwiftSocket.git", from: "2.0.2"),
    ],
    targets: [
        .target(
            name: "Network",
            dependencies: []),
        .target(
            name: "Transport",
            dependencies: ["Network"]),
        .testTarget(
            name: "TransportTests",
            dependencies: ["Transport", "Network", "Datable"]),
    ]
)
