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
            swiftSettings: defaultSettings),
        .testTarget(
            name: "DiveKitTests",
            dependencies: [
                "DiveKit",
            ],
            swiftSettings: defaultSettings)
    ],
    swiftLanguageVersions: [.v5]
)

let defaultSettings: [SwiftSetting] = [
    .unsafeFlags([
        "-Xfrontend",
        "-warn-long-function-bodies=200",
        "-Xfrontend",
        "-warn-long-expression-type-checking=100"
    ])
]
