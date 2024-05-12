import SwiftUI

internal enum LocalizedKey {
    @TaskLocal static var mainBundle: Bundle = .main
}

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

internal extension LocalizedKey {
    enum Unit {}
}

internal extension LocalizedKey.Unit {
    enum Depth {
        static let title: LocalizedStringKey = "dive.kit.unit.depth.title"
        static let shortDescriptionImperial: LocalizedStringKey = "dive.kit.unit.depth.imperial.description.short"
        static let shortDescriptionMetric: LocalizedStringKey = "dive.kit.unit.depth.metric.description.short"
        static let fullDescriptionImperial: LocalizedStringKey = "dive.kit.unit.depth.imperial.description.full"
        static let fullDescriptionMetric: LocalizedStringKey = "dive.kit.unit.depth.metric.description.full"
        static let shortQuantityImperial: LocalizedStringKey = "dive.kit.unit.depth.imperial.description.short.quantity"
        static let shortQuantityMetric: LocalizedStringKey = "dive.kit.unit.depth.metric.description.short.quantity"
        static let fullQuantityImperial: LocalizedStringKey = "dive.kit.unit.depth.imperial.description.full.quantity"
        static let fullQuantityMetric: LocalizedStringKey = "dive.kit.unit.depth.metric.description.full.quantity"
    }
}

internal extension LocalizedKey.Unit {
    enum Mass {
        static let title: LocalizedStringKey = "dive.kit.unit.mass.title"
        static let shortDescriptionImperial: LocalizedStringKey = "dive.kit.unit.mass.imperial.description.short"
        static let shortDescriptionMetric: LocalizedStringKey = "dive.kit.unit.mass.metric.description.short"
        static let fullDescriptionImperial: LocalizedStringKey = "dive.kit.unit.mass.imperial.description.full"
        static let fullDescriptionMetric: LocalizedStringKey = "dive.kit.unit.mass.metric.description.full"
        static let shortQuantityImperial: LocalizedStringKey = "dive.kit.unit.mass.imperial.description.short.quantity"
        static let shortQuantityMetric: LocalizedStringKey = "dive.kit.unit.mass.metric.description.short.quantity"
        static let fullQuantityImperial: LocalizedStringKey = "dive.kit.unit.mass.imperial.description.full.quantity"
        static let fullQuantityMetric: LocalizedStringKey = "dive.kit.unit.mass.metric.description.full.quantity"
    }
}

internal extension LocalizedKey.Unit {
    enum Volume {
        static let title: LocalizedStringKey = "dive.kit.unit.volume.title"
        static let shortDescriptionImperial: LocalizedStringKey = "dive.kit.unit.volume.imperial.description.short"
        static let shortDescriptionMetric: LocalizedStringKey = "dive.kit.unit.volume.metric.description.short"
        static let fullDescriptionImperial: LocalizedStringKey = "dive.kit.unit.volume.imperial.description.full"
        static let fullDescriptionMetric: LocalizedStringKey = "dive.kit.unit.volume.metric.description.full"
        static let shortQuantityImperial: LocalizedStringKey = "dive.kit.unit.volume.imperial.description.short.quantity"
        static let shortQuantityMetric: LocalizedStringKey = "dive.kit.unit.volume.metric.description.short.quantity"
        static let fullQuantityImperial: LocalizedStringKey = "dive.kit.unit.volume.imperial.description.full.quantity"
        static let fullQuantityMetric: LocalizedStringKey = "dive.kit.unit.volume.metric.description.full.quantity"
    }
}

internal extension LocalizedKey.Unit {
    enum Pressure {
        static let title: LocalizedStringKey = "dive.kit.unit.pressure.title"
        static let shortDescriptionImperial: LocalizedStringKey = "dive.kit.unit.pressure.imperial.description.short"
        static let shortDescriptionMetric: LocalizedStringKey = "dive.kit.unit.pressure.metric.description.short"
        static let shortDescriptionAtmospheres: LocalizedStringKey = "dive.kit.unit.pressure.atmospheres.description.short"
        static let fullDescriptionImperial: LocalizedStringKey = "dive.kit.unit.pressure.imperial.description.full"
        static let fullDescriptionMetric: LocalizedStringKey = "dive.kit.unit.pressure.metric.description.full"
        static let fullDescriptionAtmospheres: LocalizedStringKey = "dive.kit.unit.pressure.atmospheres.description.full"
        static let shortQuantityImperial: LocalizedStringKey = "dive.kit.unit.pressure.imperial.description.short.quantity"
        static let shortQuantityMetric: LocalizedStringKey = "dive.kit.unit.pressure.metric.description.short.quantity"
        static let shortQuantityAtmospheres: LocalizedStringKey = "dive.kit.unit.pressure.atmospheres.description.short.quantity"
        static let fullQuantityImperial: LocalizedStringKey = "dive.kit.unit.pressure.imperial.description.full.quantity"
        static let fullQuantityMetric: LocalizedStringKey = "dive.kit.unit.pressure.metric.description.full.quantity"
        static let fullQuantityAtmospheres: LocalizedStringKey = "dive.kit.unit.pressure.atmospheres.description.full.quantity"
    }
}
