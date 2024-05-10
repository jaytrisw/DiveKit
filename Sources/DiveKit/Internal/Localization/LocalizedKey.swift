import SwiftUI

internal enum LocalizedKey {}

internal extension LocalizedKey {
    enum Error {}
}

internal extension LocalizedKey.Error {
    enum Tank {
        static let ratedPressure: LocalizedStringKey = "dive.kit.error.tank.size.rated.pressure"
        static let volume: LocalizedStringKey = "dive.kit.error.tank.size.volume"
    }
}

internal extension LocalizedKey.Error {
    enum Blend {
        static let totalPressure: LocalizedStringKey = "dive.kit.error.blend.total.pressure"
        static let pressureRange: LocalizedStringKey = "dive.kit.error.blend.pressure.range"
    }
}

internal extension LocalizedKey.Error {
    enum Negative {
        static let depth: LocalizedStringKey = "dive.kit.error.negative.depth"
        static let fractionalPressure: LocalizedStringKey = "dive.kit.error.negative.fractional.pressure"
        static let minutes: LocalizedStringKey = "dive.kit.error.negative.minutes"
        static let pressure: LocalizedStringKey = "dive.kit.error.negative.pressure"
        static let volume: LocalizedStringKey = "dive.kit.error.negative.volume"
        static let weight: LocalizedStringKey = "dive.kit.error.negative.weight"
    }
}
