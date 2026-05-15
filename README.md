# DiveKit

<p align="center">
<img src="https://raw.githubusercontent.com/jaytrisw/DiveKit/develop/DiveKit-Logo.png" alt="drawing" width="450"/>
</p>

[![Swift](https://img.shields.io/badge/Swift-6.2-clear?labelColor=343434&color=de5d43)](https://img.shields.io/badge/Swift-6.2-clear?labelColor=343434&color=de5d43)
[![Swift Package Manager](https://img.shields.io/badge/Swift_Package_Manager-Compatible-clear?labelColor=343434&color=de5d43
)](https://img.shields.io/badge/Swift_Package_Manager-Compatible-clear?labelColor=343434&color=de5d43)

[![Build Status](https://github.com/jaytrisw/DiveKit/workflows/CI/badge.svg)](https://github.com/jaytrisw/DiveKit/actions/workflows/ci.yml)
[![Build Status](https://app.bitrise.io/app/888b1200-4cd1-4e34-a305-0ab610355179/status.svg?token=QZtC4sYSLTadUfRmuxzzmQ&branch=main)](https://app.bitrise.io/app/888b1200-4cd1-4e34-a305-0ab610355179)
[![CodeFactor](https://www.codefactor.io/repository/github/jaytrisw/divekit/badge)](https://www.codefactor.io/repository/github/jaytrisw/divekit)
[![Codecov.io](https://codecov.io/github/jaytrisw/DiveKit/graph/badge.svg?token=NOoje9nTQv)](https://codecov.io/github/jaytrisw/DiveKit)

## Development

Run SwiftLint with the Swift Package plugin:

```sh
swift package plugin --allow-writing-to-package-directory swiftlint --strict
```

SwiftLint also runs during Xcode builds through the package build-tool plugin. The first local Xcode build may ask you to trust and enable the `SwiftLintBuildToolPlugin`.

Run the macOS test plan:

```sh
xcodebuild test \
  -skipPackagePluginValidation \
  -scheme DiveKit \
  -destination 'platform=macOS' \
  -testPlan DiveKit
```

## String Catalog Sync

DiveKit includes a command plugin for copying missing library localization keys into a host app string catalog:

```sh
swift package plugin \
  --package divekit \
  --allow-writing-to-package-directory \
  catalog-sync \
  --target Sources/App/Resources/Localizable.xcstrings
```

In Xcode, run the plugin from the host project or target, then add the host app catalog path as an argument. The Xcode wrapper accepts a bare `.xcstrings` path as the target catalog, so the argument can be just:

```sh
/path/to/HostApp/Localizable.xcstrings
```

This is a missing-key sync, not a full catalog reconciliation. On first run, when the target catalog does not exist, the tool copies DiveKit's catalog to the target path. On later runs, it only adds keys that are missing from the host catalog. Existing host keys are left untouched so apps can override DiveKit's default strings or add their own translations.

Because existing keys are preserved, the tool does not update host catalog entries when DiveKit changes a default translation, adds plural variants to an existing key, or adds a new localization to an existing key. Review those existing entries manually when adopting new DiveKit releases.

When the target catalog is outside the package directory, allow writes to that directory explicitly:

```sh
swift package plugin \
  --package divekit \
  --allow-writing-to-package-directory \
  --allow-writing-to-directory /path/to/HostApp \
  catalog-sync \
  --target /path/to/HostApp/Localizable.xcstrings
```

Preview changes without writing:

```sh
swift package plugin \
  --package divekit \
  --allow-writing-to-package-directory \
  catalog-sync \
  --target Sources/App/Resources/Localizable.xcstrings \
  --dry-run
```

`catalog-sync` locates DiveKit's package catalog automatically.

For Xcode projects without a `Package.swift`, run the executable from Xcode's package checkout instead. Build the project or resolve packages first, then find the checkout:

```sh
find ~/Library/Developer/Xcode/DerivedData \
  -type d \
  -path '*/SourcePackages/checkouts/DiveKit' \
  -print
```

Use the printed path as `DIVEKIT_CHECKOUT`:

```sh
DIVEKIT_CHECKOUT=/path/from/find/SourcePackages/checkouts/DiveKit

swift run --package-path "$DIVEKIT_CHECKOUT" catalog-sync \
  --target /path/to/HostApp/Localizable.xcstrings
```

When developing DiveKit itself, the underlying executable can also be run directly with `swift run catalog-sync`.
