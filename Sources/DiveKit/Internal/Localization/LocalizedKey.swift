import SwiftUI

internal enum LocalizedKey {
    @TaskLocal static var mainBundle: Bundle = .main
}

internal extension LocalizedKey {
    enum Error {}
}

internal extension LocalizedKey.Error {
    enum Range {
        static let lowerBound: LocalizedStringResource = "dive.kit.error.range.lower.bound"
        static let upperBound: LocalizedStringResource = "dive.kit.error.range.upper.bound"
    }
}

internal extension LocalizedKey.Error {
    enum Tank {
        static let ratedPressure: LocalizedStringResource = "dive.kit.error.tank.size.rated.pressure"
        static let volume: LocalizedStringResource = "dive.kit.error.tank.size.volume"
    }
}

internal extension LocalizedKey.Error {
    enum Blend {
        static let totalPressure: LocalizedStringResource = "dive.kit.error.blend.total.pressure"
        static let pressureRange: LocalizedStringResource = "dive.kit.error.blend.pressure.range"
    }
}

internal extension LocalizedKey.Error {
    enum Negative {
        static let depth: LocalizedStringResource = "dive.kit.error.negative.depth"
        static let fractionalPressure: LocalizedStringResource = "dive.kit.error.negative.fractional.pressure"
        static let partialPressure: LocalizedStringResource = "dive.kit.error.negative.partial.pressure"
        static let minutes: LocalizedStringResource = "dive.kit.error.negative.minutes"
        static let pressure: LocalizedStringResource = "dive.kit.error.negative.pressure"
        static let volume: LocalizedStringResource = "dive.kit.error.negative.volume"
        static let weight: LocalizedStringResource = "dive.kit.error.negative.weight"
    }
}

internal extension LocalizedKey {
    enum Unit {}
}

internal extension LocalizedKey.Unit {
    enum Rate {
        static let title: LocalizedStringResource = "dive.kit.unit.rate.title"
        static let shortDescription: LocalizedStringResource = "dive.kit.unit.rate.description.short"
        static let fullDescription: LocalizedStringResource = "dive.kit.unit.rate.description.full"
        static let shortQuantity: LocalizedStringResource = "dive.kit.unit.rate.description.short.quantity"
        static let fullQuantity: LocalizedStringResource = "dive.kit.unit.rate.description.full.quantity"
    }
}

internal extension LocalizedKey.Unit {
    enum Depth {
        static let title: LocalizedStringResource = "dive.kit.unit.depth.title"
        static let shortDescriptionImperial: LocalizedStringResource = "dive.kit.unit.depth.imperial.description.short"
        static let shortDescriptionMetric: LocalizedStringResource = "dive.kit.unit.depth.metric.description.short"
        static let fullDescriptionImperial: LocalizedStringResource = "dive.kit.unit.depth.imperial.description.full"
        static let fullDescriptionMetric: LocalizedStringResource = "dive.kit.unit.depth.metric.description.full"
        static let shortQuantityImperial: LocalizedStringResource = "dive.kit.unit.depth.imperial.description.short.quantity"
        static let shortQuantityMetric: LocalizedStringResource = "dive.kit.unit.depth.metric.description.short.quantity"
        static let fullQuantityImperial: LocalizedStringResource = "dive.kit.unit.depth.imperial.description.full.quantity"
        static let fullQuantityMetric: LocalizedStringResource = "dive.kit.unit.depth.metric.description.full.quantity"
    }
}

internal extension LocalizedKey.Unit {
    enum Mass {
        static let title: LocalizedStringResource = "dive.kit.unit.mass.title"
        static let shortDescriptionImperial: LocalizedStringResource = "dive.kit.unit.mass.imperial.description.short"
        static let shortDescriptionMetric: LocalizedStringResource = "dive.kit.unit.mass.metric.description.short"
        static let fullDescriptionImperial: LocalizedStringResource = "dive.kit.unit.mass.imperial.description.full"
        static let fullDescriptionMetric: LocalizedStringResource = "dive.kit.unit.mass.metric.description.full"
        static let shortQuantityImperial: LocalizedStringResource = "dive.kit.unit.mass.imperial.description.short.quantity"
        static let shortQuantityMetric: LocalizedStringResource = "dive.kit.unit.mass.metric.description.short.quantity"
        static let fullQuantityImperial: LocalizedStringResource = "dive.kit.unit.mass.imperial.description.full.quantity"
        static let fullQuantityMetric: LocalizedStringResource = "dive.kit.unit.mass.metric.description.full.quantity"
    }
}

internal extension LocalizedKey.Unit {
    enum Volume {
        static let title: LocalizedStringResource = "dive.kit.unit.volume.title"
        static let shortDescriptionImperial: LocalizedStringResource = "dive.kit.unit.volume.imperial.description.short"
        static let shortDescriptionMetric: LocalizedStringResource = "dive.kit.unit.volume.metric.description.short"
        static let fullDescriptionImperial: LocalizedStringResource = "dive.kit.unit.volume.imperial.description.full"
        static let fullDescriptionMetric: LocalizedStringResource = "dive.kit.unit.volume.metric.description.full"
        static let shortQuantityImperial: LocalizedStringResource = "dive.kit.unit.volume.imperial.description.short.quantity"
        static let shortQuantityMetric: LocalizedStringResource = "dive.kit.unit.volume.metric.description.short.quantity"
        static let fullQuantityImperial: LocalizedStringResource = "dive.kit.unit.volume.imperial.description.full.quantity"
        static let fullQuantityMetric: LocalizedStringResource = "dive.kit.unit.volume.metric.description.full.quantity"
    }
}

internal extension LocalizedKey.Unit {
    enum Pressure {
        static let title: LocalizedStringResource = "dive.kit.unit.pressure.title"
        static let shortDescriptionImperial: LocalizedStringResource = "dive.kit.unit.pressure.imperial.description.short"
        static let shortDescriptionMetric: LocalizedStringResource = "dive.kit.unit.pressure.metric.description.short"
        static let shortDescriptionAtmospheres: LocalizedStringResource = "dive.kit.unit.pressure.atmospheres.description.short"
        static let fullDescriptionImperial: LocalizedStringResource = "dive.kit.unit.pressure.imperial.description.full"
        static let fullDescriptionMetric: LocalizedStringResource = "dive.kit.unit.pressure.metric.description.full"
        static let fullDescriptionAtmospheres: LocalizedStringResource = "dive.kit.unit.pressure.atmospheres.description.full"
        static let shortQuantityImperial: LocalizedStringResource = "dive.kit.unit.pressure.imperial.description.short.quantity"
        static let shortQuantityMetric: LocalizedStringResource = "dive.kit.unit.pressure.metric.description.short.quantity"
        static let shortQuantityAtmospheres: LocalizedStringResource = "dive.kit.unit.pressure.atmospheres.description.short.quantity"
        static let fullQuantityImperial: LocalizedStringResource = "dive.kit.unit.pressure.imperial.description.full.quantity"
        static let fullQuantityMetric: LocalizedStringResource = "dive.kit.unit.pressure.metric.description.full.quantity"
        static let fullQuantityAtmospheres: LocalizedStringResource = "dive.kit.unit.pressure.atmospheres.description.full.quantity"
    }
}
