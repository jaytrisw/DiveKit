// swift-tools-version: 5.10
import PackageDescription

let package = Package(
    name: "DiveKit",
    defaultLocalization: "en",
    platforms: [
        .macOS(.v12),
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "DiveKit",
            targets: [
                "DiveKit",
            ])
    ],
    targets: [
        .target(
            name: "DiveKit",
            resources: [
                .process("Resources")
            ]
        ),
        .testTarget(
            name: "DiveKitTests",
            dependencies: [
                "DiveKit",
            ],
            resources: [
                .process("Resources")
            ])
    ])
