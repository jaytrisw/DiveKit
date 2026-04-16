# Calculations

Use calculators to produce typed results with the configuration that produced them.

## Overview

Each calculator owns a `Configuration`. Methods return `Calculation` values so callers can keep the numeric result and the units used to produce it together.

```swift
import DiveKit

let configuration = Configuration(units: .imperial, water: .fresh)
let physicsCalculator = PhysicsCalculator(configuration: configuration)

let gaugePressureCalculation = try physicsCalculator.gaugePressure(at: 66)
```

## Physics Calculations

``PhysicsCalculator`` performs pressure and air-volume calculations.

```swift
let absolutePressure = try physicsCalculator.atmospheresAbsolute(at: 99)
let compressedVolume = try physicsCalculator.airVolumeFromSurface(to: 99, with: 80)
let surfaceVolume = try physicsCalculator.airVolumeToSurface(from: 99, with: 20)
let pressureChange = try physicsCalculator.pressureChange(from: 33, to: 99)
```

`Depth` and `Volume` inputs must be non-negative. When validation fails, these APIs throw `DiveKit.Error`.

## Gas Calculations

``GasCalculator`` performs gas planning and gas consumption calculations.

```swift
let gasCalculator = GasCalculator(configuration: configuration)
let oxygen = try FractionalPressure(of: Oxygen(), fractionalPressure: 0.32)

let partialPressure = try gasCalculator.partialPressure(
    of: oxygen,
    at: 99,
    using: physicsCalculator
)
```

Use ``GasCalculator/bestBlend(for:partialPressure:using:)``, ``GasCalculator/maximumOperatingDepth(for:in:)``, and ``GasCalculator/equivalentAirDepth(for:with:)`` for planning calculations.

Use ``GasCalculator/surfaceAirConsumption(at:for:start:end:using:)`` and ``GasCalculator/respiratoryMinuteVolume(at:for:consuming:with:using:)`` for gas consumption calculations.

## Buoyancy Calculations

``BuoyancyCalculator`` calculates object buoyancy and volume.

```swift
let buoyancyCalculator = BuoyancyCalculator(configuration: configuration)

let buoyancy = try buoyancyCalculator.buoyancyOfObject(
    weighing: 10,
    andDisplacing: 12
)
```

Weight and volume inputs must be non-negative.

## Additional API Names

`PhysicsCalculating`, `GasCalculating`, and `BuoyancyCalculating` describe calculator capabilities. `Calculation`, `DecimalResult`, `ResultRepresentable`, and `DecimalResultRepresentable` describe calculation result values.

## Topics

### Calculator Types

- ``PhysicsCalculator``
- ``GasCalculator``
- ``BuoyancyCalculator``
