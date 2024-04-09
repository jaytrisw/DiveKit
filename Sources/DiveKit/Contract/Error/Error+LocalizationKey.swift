import Foundation

public extension Error {
    var localizationKey: String {
        switch self {
            case let .input(input, _): input.localizationKey
        }
    }
}

public extension Error.Input {
    var localizationKey: String {
        switch self {
            case let .negative(negative): negative.localizationKey
            case let .invalid(invalid): invalid.localizationKey
        }
    }
}

public extension Error.Input.Invalid {
    var localizationKey: String {
        switch self {
            case .object: "invalid.object"
            case .blend: "invalid.blend"
            case .tank: "invalid.tank"
        }
    }
}

public extension Error.Input.Negative {
    var localizationKey: String {
        switch self {
            case .depth: "negative.depth"
            case .fractionalPressure: "negative.fractional.pressure"
            case .minutes: "negative.minutes"
            case .pressure: "negative.pressure"
            case .volume: "negative.volume"
            case .weight: "negative.weight"
        }
    }
}
