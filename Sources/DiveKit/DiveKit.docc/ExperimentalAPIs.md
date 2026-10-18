# Experimental APIs

Opt in to decompression, trimix, and narcotic-depth calculations that have not been validated.

## Overview

Some DiveKit APIs are marked `@_spi(Experimental)`. They are public and ship in releases, but they don't appear in this documentation, and a client must opt in to use them:

```swift
@_spi(Experimental) import DiveKit
```

> Warning: These calculations have not been validated for planning real dives. Do not use them as a substitute for a dive computer, published tables, or training.

They stay experimental until they have been validated. Each symbol's own documentation, available in Xcode's Quick Help after opting in, describes its inputs, errors, and limitations.

## What Is Experimental

### Decompression

`BuhlmannCalculator` implements the Bühlmann ZH-L16C model with gradient factors. It tracks inert gas in a diver's tissues and calculates:

- the ceiling, the shallowest depth the tissues tolerate;
- the no-decompression limit at a depth;
- an ascent schedule with decompression stops and gas switches.

```swift
@_spi(Experimental) import DiveKit

let calculator = BuhlmannCalculator(configuration: .init(units: .metric, water: .salt))
let tissues = try calculator.loaded(
    try calculator.surfaceTissues(),
    through: [
        try DiveSegment(start: .init(0), end: .init(40), duration: .init(2), blend: .air),
        try DiveSegment(start: .init(40), end: .init(40), duration: .init(25), blend: .air)
    ])
let schedule = try calculator.schedule(
    of: tissues,
    from: .init(40),
    breathing: .air,
    switchingTo: [try .enrichedAir(0.5)])
```

Change the gradient factors, ascent rate, and stop depths through `BuhlmannCalculator.Settings`:

```swift
var settings = BuhlmannCalculator.Settings.defaults(for: .metric)
settings.gradientFactors = try .init(low: try .init(0.3), high: try .init(0.85))
settings.ascent = try AscentProfile(rate: .init(9), stopInterval: .init(3), lastStop: .init(3))
let calculator = BuhlmannCalculator(configuration: configuration, settings: settings)
```

The calculator is built on lower-level building blocks that are also available: `Tissue` for compartment loading with the Schreiner and Haldane equations, and `Buhlmann.Table` for coefficient tables, ceilings, no-decompression limits, and schedules on compartments loaded by hand.

Schedules are checked against decotengu, an independent ZH-L16-GF planner.

### Helium and Trimix

`Helium` is available as a gas, and `Blend.trimix(oxygen:helium:)` builds a validated oxygen, helium, and nitrogen mix.

```swift
let trimix = try Blend.trimix(oxygen: 0.18, helium: 0.45)
```

### Equivalent Narcotic Depth

`GasCalculator.equivalentNarcoticDepth(for:with:treating:)` calculates END from each gas's narcotic potency. Oxygen is not narcotic by default; pass `.narcotic(.oxygen)` to treat it as narcotic, as many agencies do.

```swift
let end = try gasCalculator.equivalentNarcoticDepth(
    for: 60,
    with: trimix,
    treating: .narcotic(.oxygen))
```

## Limitations

The limitations in <doc:DiveKit> apply here too. In particular, surface pressure is fixed at one atmosphere, so at altitude no-decompression limits are too long and ceilings too shallow.
