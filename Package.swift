// swift-tools-version: 5.10
import PackageDescription

let package = Package(
    name: "DiveKit",
    products: [
        .library(
            name: "DiveKit",
            targets: [
                "DiveKit",
            ])
    ],
    targets: [
        .target(
            name: "DiveKit"),
        .testTarget(
            name: "DiveKitTests",
            dependencies: [
                "DiveKit",
            ])
    ])
