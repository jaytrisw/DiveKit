import Foundation

public extension Error {

    @TaskLocal internal static var mainBundle: Bundle = .main

    var localizationKey: String {
        switch self {
            case let .negative(negative, _): negative.localizationKey
            case let .tank(tank, _): tank.localizationKey
            case let .blend(blend, _): blend.localizationKey
        }
    }

    var localizedDescription: String {
        guard NSLocalizedString(localizationKey, bundle: Error.mainBundle, comment: .init(describing: self)) != localizationKey else {
            return NSLocalizedString(localizationKey, bundle: .module, comment: .init(describing: self))
        }
        return NSLocalizedString(localizationKey, bundle: Error.mainBundle, comment: .init(describing: self))
    }
}

public extension Error.Tank {
    var localizationKey: String {
        switch self {
            case .ratedPressure: "dive.kit.error.tank.size.rated.pressure"
            case .volume: "dive.kit.error.tank.size.volume"
        }
    }
}

public extension Error.Blend {
    var localizationKey: String {
        switch self {
            case .totalPressure: "dive.kit.error.blend.total.pressure"
            case .pressureRange: "dive.kit.error.blend.pressure.range"
        }
    }
}

public extension Error.Negative {
    var localizationKey: String {
        switch self {
            case .depth: "dive.kit.error.negative.depth"
            case .fractionalPressure: "dive.kit.error.negative.fractional.pressure"
            case .minutes: "dive.kit.error.negative.minutes"
            case .pressure: "dive.kit.error.negative.pressure"
            case .volume: "dive.kit.error.negative.volume"
            case .weight: "dive.kit.error.negative.weight"
        }
    }
}
