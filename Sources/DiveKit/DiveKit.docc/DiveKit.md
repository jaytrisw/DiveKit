# DiveKit

Build diving calculations with typed values, validated gas blends, localized units, and domain-specific errors.

## Overview

DiveKit provides calculators and model types for common recreational diving calculations. The public `DiveKit` module re-exports the core domain types and adds validated construction, convenience APIs, and localization support.

Use `Configuration` to choose a unit system and water model, then create a calculator for the domain you need:

```swift
import DiveKit

let configuration = Configuration(units: .metric, water: .salt)
let physicsCalculator = PhysicsCalculator(configuration: configuration)

let absolutePressure = try physicsCalculator.atmospheresAbsolute(at: 30)
```

Throwing APIs use typed throws and throw `DiveKit.Error` for recoverable domain failures, such as negative inputs, range violations, invalid blends, and invalid tank values.

```swift
do {
    let oxygen = try FractionalPressure(of: Oxygen(), fractionalPressure: 0.32)
    let partialPressure = try GasCalculator(configuration: configuration)
        .partialPressure(of: oxygen, at: 30, using: physicsCalculator)
    print(partialPressure.result.value)
} catch {
    // `error` is already a `DiveKit.Error`.
    print(error.localizedDescription)
}
```

### Configuration

Calculators use a `Configuration` to determine units and water behavior.

```swift
let metricSalt = Configuration(units: .metric, water: .salt)
let imperialFresh = Configuration(units: .imperial, water: .fresh)
```

The selected unit system controls result units such as `Depth.Unit`, `Pressure.Unit`, `Mass.Unit`, and `Volume.Unit`. The selected water model controls water density and pressure increase per atmosphere.

### Calculators

DiveKit includes three calculator types:

- ``PhysicsCalculator`` for pressure and volume calculations.
- ``GasCalculator`` for partial pressure, blend planning, MOD, EAD, SAC, and RMV calculations.
- ``BuoyancyCalculator`` for object buoyancy and related volume calculations.

Each calculator stores the configuration used to produce `Calculation` values.

### Blends

Gas blends use state markers to distinguish mixes that are still being assembled from mixes that have been validated.

```swift
let nitrox32 = try Blend<Unblended>()
    .adding(Oxygen(), pressure: 0.32)
    .filling(with: Nitrogen())
    .blend()
```

Use `Blend` in the `Unblended` state while building a mix, then call `blend()` to validate that the total fractional pressure equals `1`.

### Localization

DiveKit includes localization helpers for unit titles, descriptions, quantities, and formatted decimal values.

```swift
let depth = Depth(30)
let formattedDepth = depth.formatted(.depth(.meters, style: .short))
```

### Limitations

DiveKit's calculations have not been validated for planning real dives. Do not use them as a substitute for a dive computer, published tables, or training.

- **Sea level only.** Surface pressure is fixed at one atmosphere. DiveKit does not model altitude, so do not rely on any result that depends on ambient pressure at altitude.
- **Ideal gas.** Respiratory minute volume treats gas as ideal, with no compressibility factor, which overstates the gas in a high-pressure cylinder by several percent.
- **Unit conventions.** Metric salt water uses 10 m and imperial salt water 33 ft per atmosphere. These differ by about 0.6%, so the same dive gives slightly different results in each unit system.

## Additional API Names

### Essentials

- `Configuration`
- `Units`
- `Water`

### Calculations

- `Calculation`
- `PhysicsCalculating`
- `GasCalculating`
- `BuoyancyCalculating`

### Domain Values

- `Depth`
- `Mass`
- `Minutes`
- `Pressure`
- `Volume`
- `Rate`
- `PartialPressure`
- `FractionalPressure`
- `Buoyancy`
- `Object`
- `Tank`

### Gas Blends

- `Blend`
- `BlendState`
- `Blended`
- `Unblended`
- `GasRepresentable`
- `Oxygen`
- `Nitrogen`
- `NarcoticPotency`

### Localization

- `LocalizationStyle`
- `LocalizationComponent`
- `LocalizationProviding`
- `DecimalUnitLocalizable`
- `DecimalUnitFormatStyle`

### Errors

- `Error`
- `CallSite`

## Topics

### Articles

- <doc:GettingStarted>
- <doc:Calculations>
- <doc:GasBlends>
- <doc:Localization>
- <doc:Errors>
- <doc:ExperimentalAPIs>

### Calculators

- ``PhysicsCalculator``
- ``GasCalculator``
- ``BuoyancyCalculator``
