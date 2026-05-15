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
                "DiveKit"
            ]),
        .executable(
            name: "catalog-sync",
            targets: [
                "catalog-sync"
            ]),
        .plugin(
            name: "DiveKitCatalogSyncPlugin",
            targets: [
                "DiveKitCatalogSyncPlugin"
            ])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.5.0"),
        .package(url: "https://github.com/swiftlang/swift-docc-plugin", from: "1.4.6"),
        .package(url: "https://github.com/SimplyDanny/SwiftLintPlugins", from: "0.63.2")
    ],
    targets: [
        .executableTarget(
            name: "catalog-sync",
            dependencies: [
                "DiveKitCatalogSyncCore",
                .product(name: "ArgumentParser", package: "swift-argument-parser")
            ],
            path: "Sources/DiveKitCatalogSync",
            plugins: [
                .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")
            ]
        ),
        .target(
            name: "DiveKitCatalogSyncCore",
            plugins: [
                .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")
            ]
        ),
        .plugin(
            name: "DiveKitCatalogSyncPlugin",
            capability: .command(
                intent: .custom(
                    verb: "catalog-sync",
                    description: "Copy missing DiveKit string catalog keys into a host app catalog."
                ),
                permissions: [
                    .writeToPackageDirectory(
                        reason: "This command creates or updates host app string catalogs."
                    )
                ]
            ),
            dependencies: [
                .target(name: "catalog-sync")
            ]
        ),
        .target(
            name: "DiveKit",
            dependencies: [
                "DiveKitCore",
                "DiveKitInternal",
                "DiveKitLocalization"
            ],
            plugins: [
                .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")
            ]
        ),
        .target(
            name: "DiveKitCore",
            plugins: [
                .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")
            ]
        ),
        .target(
            name: "DiveKitInternal",
            dependencies: [
                "DiveKitCore"
            ],
            plugins: [
                .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")
            ]
        ),
        .target(
            name: "DiveKitLocalization",
            dependencies: [
                "DiveKitCore",
                "DiveKitInternal"
            ],
            resources: [
                .process("Resources")
            ],
            plugins: [
                .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")
            ]
        ),
        .testTarget(
            name: "DiveKitCatalogSyncTests",
            dependencies: [
                "DiveKitCatalogSyncCore"
            ],
            plugins: [
                .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")
            ]),
        .testTarget(
            name: "DiveKitTests",
            dependencies: [
                "DiveKit"
            ],
            resources: [
                .process("Resources")
            ],
            plugins: [
                .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")
            ])
    ])
