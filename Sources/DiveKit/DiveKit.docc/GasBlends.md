# Gas Blends

Build gas mixtures with fractional pressures and validate them before use.

## Overview

`Blend` uses a state marker to distinguish an incomplete or unvalidated mix from a validated mix.

- `Blend` in the `Unblended` state can be edited.
- `Blend` in the `Blended` state represents a mix that has passed blend validation.

## Build a Blend

Start with an empty unblended mix, add gases, and validate it.

```swift
let nitrox32 = try Blend<Unblended>()
    .adding(Oxygen(), pressure: 0.32)
    .filling(with: Nitrogen())
    .blend()
```

The total fractional pressure must equal `1`.

## Use Fractional Pressures

Create validated fractional pressures with `FractionalPressure(of:fractionalPressure:)`.

```swift
let oxygen = try FractionalPressure(of: Oxygen(), fractionalPressure: 0.21)
let nitrogen = try FractionalPressure(of: Nitrogen(), fractionalPressure: 0.79)

let air = try Blend<Unblended>(oxygen, nitrogen).blend()
```

Fractional pressure values must be within `0...1`.

## Use Preset Blends

Use `Blend.air` for standard air or `Blend.enrichedAir(_:)` for Nitrox-style mixes.

```swift
let air = Blend.air
let ean32 = try Blend.enrichedAir(0.32)
```

## Additional API Names

### Blend Types

- `Blend`
- `BlendState`
- `Blended`
- `Unblended`

### Gas Types

- `GasRepresentable`
- `Oxygen`
- `Nitrogen`
- `Trace`

### Fractional Pressure

- `FractionalPressure`
- `PartialPressure`
