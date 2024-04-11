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
            case let .tank(tank): tank.localizationKey
            case let .blend(blend): blend.localizationKey
        }
    }
}

public extension Error.Input.Tank {
    var localizationKey: String {
        switch self {
            case .ratedPressure: "tank.size.rated.pressure"
            case .volume: "tank.size.volume"
        }
    }
}

public extension Error.Input.Blend {
    var localizationKey: String {
        switch self {
            case .totalPressure: "blend.total.pressure"
            case .pressureRange: "blend.pressure.range"
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
