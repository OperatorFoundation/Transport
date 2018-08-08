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
        .package(url: "https://github.com/OperatorFoundation/Datable.git", from: "0.1.2"),
    ],
    targets: [
        .target(
            name: "Transport",
            dependencies: []),
        .testTarget(
            name: "TransportTests",
            dependencies: ["Transport","Datable"]),
    ]
)
