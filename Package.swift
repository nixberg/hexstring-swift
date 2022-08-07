// swift-tools-version:5.6

import PackageDescription

let package = Package(
    name: "hexstring-swift",
    products: [
        .library(
            name: "HexString",
            targets: ["HexString"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-algorithms", from: "1.0.0"),
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
