// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Transport",
    platforms: [
       .macOS(.v10_14)
    ],
    products: [
        .library(
            name: "Transport",
            targets: ["Transport"]),
    ],
    dependencies: [
        .package(url: "https://github.com/OperatorFoundation/Datable.git", from: "2.0.1")
    ],
    targets: [
        .target(
            name: "Transport",
            dependencies: []),
        .testTarget(
            name: "TransportTests",
            dependencies: ["Transport", "Datable"]),
    ]
)
