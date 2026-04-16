# Calculations

Use calculators to produce typed results with the configuration that produced them.

## Overview

Each calculator owns a `Configuration`. Methods return `Calculation` values so callers can keep the numeric result and the units used to produce it together.

```swift
let configuration = Configuration(units: .imperial, water: .fresh)
let physics = PhysicsCalculator(configuration: configuration)

let gaugePressure = try physics.gaugePressure(at: 66)
```

## Physics Calculations

`PhysicsCalculator` performs pressure and air-volume calculations.

```swift
let absolute = try physics.atmospheresAbsolute(at: 99)
let compressed = try physics.airVolumeFromSurface(to: 99, with: 80)
let expanded = try physics.airVolumeToSurface(from: 99, with: 20)
let change = try physics.pressureChange(from: 33, to: 99)
```

`Depth` and `Volume` inputs must be non-negative. When validation fails, these APIs throw `Error`.

## Gas Calculations

`GasCalculator` performs gas planning and gas consumption calculations.

```swift
let gas = GasCalculator(configuration: configuration)
let oxygen = try FractionalPressure(of: Oxygen(), fractionalPressure: 0.32)

let partialPressure = try gas.partialPressure(
    of: oxygen,
    at: 99,
    using: physics
)
```

Use `bestBlend(for:partialPressure:using:)`, `maximumOperatingDepth(for:in:)`, and `equivalentAirDepth(for:with:)` for planning calculations.

Use `surfaceAirConsumption(at:for:start:end:using:)` and `respiratoryMinuteVolume(at:for:consuming:with:using:)` for gas consumption calculations.

## Buoyancy Calculations

`BuoyancyCalculator` calculates object buoyancy and volume.

```swift
let buoyancy = BuoyancyCalculator(configuration: configuration)

let result = try buoyancy.buoyancyOfObject(
    weighing: 10,
    andDisplacing: 12
)
```

Weight and volume inputs must be non-negative.

## Related APIs

### Calculator Types

- `PhysicsCalculator`
- `GasCalculator`
- `BuoyancyCalculator`

### Calculator Protocols

- `PhysicsCalculating`
- `GasCalculating`
- `BuoyancyCalculating`

### Result Types

- `Calculation`
- `DecimalResult`
- `ResultRepresentable`
- `DecimalResultRepresentable`
