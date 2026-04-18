import Foundation
import DiveKitCore

package extension Error {
    /// The localization key for this domain error.
    ///
    /// - Since: 1.0.0
    var localizationKey: String {
        switch self {
            case let .negative(negative, _): negative.localizationKey
            case let .tank(tank, _): tank.localizationKey
            case let .blend(blend, _): blend.localizationKey
            case let .range(range, _): range.localizationKey
        }
    }
}

package extension Error.Range {
    /// The localization key for this range error payload.
    ///
    /// - Since: 1.0.0
    var localizationKey: String {
        String {
            switch self {
                case .lowerBound: LocalizedKey.Error.Range.lowerBound
                case .upperBound: LocalizedKey.Error.Range.upperBound
            }
        }
    }
}

package extension Error.Tank {
    /// The localization key for this tank error payload.
    ///
    /// - Since: 1.0.0
    var localizationKey: String {
        String {
            switch self {
                case .ratedPressure: LocalizedKey.Error.Tank.ratedPressure
                case .volume: LocalizedKey.Error.Tank.volume
            }
        }
    }
}

package extension Error.Blend {
    /// The localization key for this blend error payload.
    ///
    /// - Since: 1.0.0
    var localizationKey: String {
        String {
            switch self {
                case .totalPressure: LocalizedKey.Error.Blend.totalPressure
                case .pressureRange: LocalizedKey.Error.Blend.pressureRange
            }
        }
    }
}

package extension Error.Negative {
    /// The localization key for this negative input error payload.
    ///
    /// - Since: 1.0.0
    var localizationKey: String {
        String {
            switch self {
                case .depth: LocalizedKey.Error.Negative.depth
                case .fractionalPressure: LocalizedKey.Error.Negative.fractionalPressure
                case .partialPressure: LocalizedKey.Error.Negative.partialPressure
                case .minutes: LocalizedKey.Error.Negative.minutes
                case .pressure: LocalizedKey.Error.Negative.pressure
                case .volume: LocalizedKey.Error.Negative.volume
                case .weight: LocalizedKey.Error.Negative.weight
            }
        }
    }
}
