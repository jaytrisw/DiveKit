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

DiveKit includes a small CLI for copying missing library localization keys into a host app string catalog:

```sh
swift run divekit-catalog-sync \
  --target /path/to/HostApp/Localizable.xcstrings
```

On first run, when the target catalog does not exist, the tool copies DiveKit's catalog to the target path. On later runs, it only adds keys that are missing from the host catalog. Existing host keys are left untouched so apps can override DiveKit's default strings or add their own translations.

When running the tool outside the DiveKit package root, pass the package catalog explicitly:

```sh
swift run divekit-catalog-sync \
  --source /path/to/DiveKit/Sources/DiveKitLocalization/Resources/Localizable.xcstrings \
  --target /path/to/HostApp/Localizable.xcstrings
```

Preview changes without writing:

```sh
swift run divekit-catalog-sync \
  --target /path/to/HostApp/Localizable.xcstrings \
  --dry-run
```
