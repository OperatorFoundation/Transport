// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

#if os(macOS)
let package = Package(
    name: "Transport",
    platforms: [
        .macOS(.v10_14),
        .iOS(.v14)
    ],
    products: [
        .library(
            name: "Transport",
            targets: ["Transport"]),
    ],
    dependencies: [
        .package(url: "https://github.com/OperatorFoundation/Datable.git", from: "3.0.6"),
    ],
    targets: [
        .target(
            name: "Transport",
            dependencies: []),
        .testTarget(
            name: "TransportTests",
            dependencies: ["Transport", "Datable"]),
    ],
    swiftLanguageVersions: [.v5]
)
#else
let package = Package(
    name: "Transport",
    products: [
        .library(
            name: "Transport",
            targets: ["Transport"]),
    ],
    dependencies: [
        .package(url: "https://github.com/OperatorFoundation/Datable.git", from: "3.0.6"),
        .package(url: "https://github.com/OperatorFoundation/NetworkLinux.git", from: "0.4.1"),
    ],
    targets: [
        .target(
            name: "Transport",
            dependencies: ["NetworkLinux"]),
        .testTarget(
            name: "TransportTests",
            dependencies: ["Transport", "Datable"]),
    ],
    swiftLanguageVersions: [.v5]
)
#endif
