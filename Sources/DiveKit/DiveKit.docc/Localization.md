# Localization

Format DiveKit values with localized unit names, descriptions, and quantities.

## Overview

DiveKit provides localization protocols and format styles for decimal domain values. Use them to format values such as depth, mass, pressure, volume, and rates.

```swift
let depth = Depth(30)
let text = depth.formatted(.depth(.meters, style: .short))
```

## Format Raw Values

You can also format a raw `Double` when the format style supplies the domain type.

```swift
let text = 30.0.formatted(.depth(.meters, style: .full))
```

## Format Rates

Rates use the base unit they are measured per minute in.

```swift
let rate = Rate<Pressure>(18)
let text = rate.formatted(.rate(.perMinute(.bar), style: .short))
```

## Localize Units

Units provide localized titles, descriptions, and quantity strings.

```swift
let title = Pressure.Unit.bar.localizedTitle
let description = Pressure.Unit.bar.localizedDescription(for: .full)
```

## Related APIs

### Localization Types

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
