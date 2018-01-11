// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Transport",
    products: [
        .library(
            name: "Transport",
            targets: ["Transport"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "Transport",
            dependencies: []),
        .testTarget(
            name: "TransportTests",
            dependencies: ["Transport"]),
    ]
)
