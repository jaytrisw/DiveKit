import Foundation

internal extension Error {
    var localizationKey: String {
        switch self {
            case let .negative(negative, _): negative.localizationKey
            case let .tank(tank, _): tank.localizationKey
            case let .blend(blend, _): blend.localizationKey
        }
    }
}

internal extension Error.Tank {
    var localizationKey: String {
        String {
            switch self {
                case .ratedPressure: LocalizedKey.Error.Tank.ratedPressure
                case .volume: LocalizedKey.Error.Tank.volume
            }
        }
    }
}

internal extension Error.Blend {
    var localizationKey: String {
        String {
            switch self {
                case .totalPressure: LocalizedKey.Error.Blend.totalPressure
                case .pressureRange: LocalizedKey.Error.Blend.pressureRange
            }
        }
    }
}

internal extension Error.Negative {
    var localizationKey: String {
        String {
            switch self {
                case .depth: LocalizedKey.Error.Negative.depth
                case .fractionalPressure: LocalizedKey.Error.Negative.fractionalPressure
                case .minutes: LocalizedKey.Error.Negative.minutes
                case .pressure: LocalizedKey.Error.Negative.pressure
                case .volume: LocalizedKey.Error.Negative.volume
                case .weight: LocalizedKey.Error.Negative.weight
            }
        }
    }
}
