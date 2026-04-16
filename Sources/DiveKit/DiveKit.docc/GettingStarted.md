# Getting Started

Create a configuration, choose a calculator, and work with typed results.

## Overview

DiveKit calculations are built around three ideas:

- A `Configuration` supplies units and water behavior.
- Calculators perform domain-specific work.
- A `Calculation` stores both the result and the configuration that produced it.

## Create a Configuration

Use a unit system and water model to create a configuration.

```swift
import DiveKit

let configuration = Configuration(units: .metric, water: .salt)
```

Use `.metric` for meters, kilograms, bar, and liters. Use `.imperial` for feet, pounds, PSI, and cubic feet.

## Run a Calculation

Create a calculator with the configuration and call a calculation method.

```swift
let physicsCalculator = PhysicsCalculator(configuration: configuration)
let pressure = try physicsCalculator.atmospheresAbsolute(at: 30)

print(pressure.result.value)
print(pressure.result.unit)
```

The result is typed. For example, `atmospheresAbsolute(at:)` returns a `Calculation` whose result is a `DecimalResult` of `Pressure`.

## Handle Errors

Throwing DiveKit APIs throw `DiveKit.Error`.

```swift
do {
    let pressure = try physicsCalculator.gaugePressure(at: -10)
} catch let error as DiveKit.Error {
    print(error.localizedDescription)
}
```

Use the error cases to inspect validation failures programmatically.

## Format Values

Use localization format styles to render values with localized units.

```swift
let depth = Depth(30)
let formattedDepth = depth.formatted(.depth(.meters, style: .short))
```

## Additional API Names

`Configuration`, `Calculation`, and `Error` are the core names used in this walkthrough.

## Topics

### Calculators

- ``PhysicsCalculator``
- ``GasCalculator``
- ``BuoyancyCalculator``

### Next Steps

- <doc:Calculations>
- <doc:GasBlends>
- <doc:Localization>
- <doc:Errors>
