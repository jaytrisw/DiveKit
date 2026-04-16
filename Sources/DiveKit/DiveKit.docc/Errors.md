# Errors

Handle recoverable validation and calculation failures with `DiveKit.Error`.

## Overview

DiveKit throwing APIs use typed throws and throw `DiveKit.Error`. Each error includes a `CallSite` so diagnostics can identify where the failure originated.

```swift
func printGaugePressure(at depth: Depth, configuration: Configuration) {
    let physicsCalculator = PhysicsCalculator(configuration: configuration)

    do {
        let gaugePressure = try physicsCalculator.gaugePressure(at: depth)
        print(gaugePressure.result.value)
    } catch let error as DiveKit.Error {
        print(error.localizedDescription)
    }
}
```

## Error Categories

`DiveKit.Error` groups failures by domain:

- `negative` for values that must not be negative.
- `range` for lower-bound or upper-bound violations.
- `blend` for gas blend validation failures.
- `tank` for tank size validation failures.

## Localized Descriptions

`DiveKit.Error` conforms to `LocalizedError` through DiveKit's localization support.

```swift
func localizedErrorMessage(for depth: Depth, configuration: Configuration) -> String? {
    let physicsCalculator = PhysicsCalculator(configuration: configuration)

    do {
        _ = try physicsCalculator.gaugePressure(at: depth)
        return nil
    } catch let error as DiveKit.Error {
        return error.localizedDescription
    }
}
```

## Additional API Names

### Error Types

- `Error`
- `CallSite`
