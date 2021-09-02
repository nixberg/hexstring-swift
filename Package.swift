// swift-tools-version:5.4

import PackageDescription

let package = Package(
    name: "hexstring-swift",
    products: [
        .library(
            name: "HexString",
            targets: ["HexString"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-algorithms", from: "0.1.1"),
    ],
    targets: [
        .target(
            name: "HexString",
            dependencies: [
                .product(name: "Algorithms", package: "swift-algorithms"),
            ]),
        .testTarget(
            name: "HexStringTests",
            dependencies: ["HexString"]),
    ]
)
