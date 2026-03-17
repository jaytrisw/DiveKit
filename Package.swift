// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "DiveKit",
    defaultLocalization: "en",
    platforms: [
        .macOS(.v13),
        .iOS(.v16)
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
