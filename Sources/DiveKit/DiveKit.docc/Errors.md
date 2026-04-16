# Errors

Handle recoverable validation and calculation failures with `Error`.

## Overview

DiveKit throwing APIs use typed throws and throw `Error`. Each error includes a `CallSite` so diagnostics can identify where the failure originated.

```swift
do {
    let fraction = try FractionalPressure(of: Oxygen(), fractionalPressure: 1.4)
} catch let error as DiveKit.Error {
    print(error.localizedDescription)
}
```

## Error Categories

`Error` groups failures by domain:

- `negative` for values that must not be negative.
- `range` for lower-bound or upper-bound violations.
- `blend` for gas blend validation failures.
- `tank` for tank size validation failures.

## Localized Descriptions

`Error` conforms to `LocalizedError` through DiveKit's localization support.

```swift
let message = error.localizedDescription
```

## Related APIs

### Error Types

- `Error`
- `CallSite`
