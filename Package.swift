// swift-tools-version: 5.10
import PackageDescription

let package = Package(
    name: "DiveKit",
    platforms: [
        .macOS(.v10_15),
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
