# Localization

Format DiveKit values with localized unit names, descriptions, and quantities.

## Overview

DiveKit provides localization protocols and format styles for decimal domain values. Use them to format values such as depth, mass, pressure, volume, and rates.

```swift
let depth = Depth(30)
let formattedDepth = depth.formatted(.depth(.meters, style: .short))
```

Use a locale or precision when the caller needs a specific numeric presentation.

```swift
let pressureIncrease = Depth(33)
let formattedPressureIncrease = pressureIncrease.formatted(
    .depth(.feet, style: .short)
        .precision(.fractionLength(1))
        .locale(Locale(identifier: "en_US")))
```

## Format Raw Values

You can also format a raw `Double` when the format style supplies the domain type.

```swift
let formattedDepth = 30.0.formatted(.depth(.meters, style: .full))
```

## Format Rates

Rates use the base unit they are measured per minute in.

```swift
let rate = Rate<Pressure>(18)
let formattedRate = rate.formatted(.rate(.perMinute(.bar), style: .short))
```

## Localize Units

Units provide localized titles, descriptions, and quantity strings.

```swift
let localizedTitle = Pressure.Unit.bar.localizedTitle
let localizedDescription = Pressure.Unit.bar.localizedDescription(for: .full)
```

## Use a Custom Strings Catalog

DiveKit resolves localized strings through `Localization.standard.resolver`.
Install a resolver during app startup when an app or package provides DiveKit
strings in a custom bundle or catalog. The bundle must expose the table through
Foundation localization lookup.

If the strings live in the app's default `Localizable` catalog, pass the app
bundle.

```swift
Localization.standard.set(.catalog(in: .main))
```

If the strings live in a separate catalog, pass its table name.

```swift
Localization.standard.set(
    .catalog(
        named: "DiveKit",
        in: .main))
```

If the catalog lives in a Swift package, pass that package's resource bundle.

```swift
Localization.standard.set(
    .catalog(
        named: "DiveKit",
        in: Bundle.module))
```

For custom lookup behavior, install a resolver closure directly.

```swift
Localization.standard.set { key, arguments in
    let localized = String(localized: key, table: "DiveKit", bundle: .main)

    guard !arguments.isEmpty else {
        return localized
    }

    return String(format: localized, locale: .current, arguments: arguments)
}
```

All unit localization and formatting APIs use the active resolver.

```swift
let depth = Depth(33)
let formattedDepth = depth.formatted(.depth(.feet, style: .full))
```

## Additional API Names

### Localization Types

- `Localization`
- `LocalizationResolver`
- `LocalizationStyle`
- `LocalizationComponent`
- `LocalizationProviding`
- `LocalizedTitleProviding`
- `LocalizedDescriptionProviding`

### Formatting

- `DecimalUnitLocalizable`
- `DecimalUnitFormatStyle`
- `DecimalUnitLocalizable.formatted(_:)`
- `Double.formatted(_:)`
