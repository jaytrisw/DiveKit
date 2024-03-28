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
            name: "DiveKit",
            dependencies: [
                "DiveKitCore",
                "DiveKitInternals"
            ],
            swiftSettings: defaultSettings),
        .target(
            name: "DiveKitCore",
            swiftSettings: defaultSettings),
        .target(
            name: "DiveKitInternals",
            dependencies: [
                "DiveKitCore"
            ],
            swiftSettings: defaultSettings),
        .testTarget(
            name: "DiveKitTests",
            dependencies: [
                "DiveKit",
                "DiveKitCore",
                "DiveKitInternals"
            ]),
        .testTarget(
            name: "DiveKitCoreTests",
            dependencies: [
                "DiveKitCore"
            ]),
        .testTarget(
            name: "DiveKitInternalsTests",
            dependencies: [
                "DiveKitInternals"
            ])
    ],
    swiftLanguageVersions: [.v5]
)

let defaultSettings: [SwiftSetting] = [
    .unsafeFlags([
        "-Xfrontend",
        "-warn-long-function-bodies=50",
        "-Xfrontend",
        "-warn-long-expression-type-checking=50"
    ])
]
