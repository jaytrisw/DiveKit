import SwiftUI
import DiveKitCore

/// Namespace for localization resources used by DiveKitLocalization.
///
/// - Since: 1.0.0
package enum LocalizedKey {
    /// The bundle searched before falling back to the module bundle.
    ///
    /// - Since: 1.0.0
    @TaskLocal package static var mainBundle: Bundle = .main
}

package extension LocalizedKey {
    /// Namespace for error localization keys.
    ///
    /// - Since: 1.0.0
    enum Error {}
}

package extension LocalizedKey.Error {
    /// Namespace for range error localization keys.
    ///
    /// - Since: 1.0.0
    enum Range {
        /// Localization key for lower-bound range errors.
        ///
        /// - Since: 1.0.0
        static let lowerBound: LocalizedStringResource = "dive.kit.error.range.lower.bound"
        /// Localization key for upper-bound range errors.
        ///
        /// - Since: 1.0.0
        static let upperBound: LocalizedStringResource = "dive.kit.error.range.upper.bound"
    }
}

package extension LocalizedKey.Error {
    /// Namespace for tank error localization keys.
    ///
    /// - Since: 1.0.0
    enum Tank {
        /// Localization key for tank rated-pressure errors.
        ///
        /// - Since: 1.0.0
        static let ratedPressure: LocalizedStringResource = "dive.kit.error.tank.size.rated.pressure"
        /// Localization key for tank volume errors.
        ///
        /// - Since: 1.0.0
        static let volume: LocalizedStringResource = "dive.kit.error.tank.size.volume"
    }
}

package extension LocalizedKey.Error {
    /// Namespace for blend error localization keys.
    ///
    /// - Since: 1.0.0
    enum Blend {
        /// Localization key for blend total-pressure errors.
        ///
        /// - Since: 1.0.0
        static let totalPressure: LocalizedStringResource = "dive.kit.error.blend.total.pressure"
        /// Localization key for blend pressure-range errors.
        ///
        /// - Since: 1.0.0
        static let pressureRange: LocalizedStringResource = "dive.kit.error.blend.pressure.range"
    }
}

package extension LocalizedKey.Error {
    /// Namespace for negative input error localization keys.
    ///
    /// - Since: 1.0.0
    enum Negative {
        /// Localization key for negative depth errors.
        ///
        /// - Since: 1.0.0
        static let depth: LocalizedStringResource = "dive.kit.error.negative.depth"
        /// Localization key for negative fractional-pressure errors.
        ///
        /// - Since: 1.0.0
        static let fractionalPressure: LocalizedStringResource = "dive.kit.error.negative.fractional.pressure"
        /// Localization key for negative partial-pressure errors.
        ///
        /// - Since: 1.0.0
        static let partialPressure: LocalizedStringResource = "dive.kit.error.negative.partial.pressure"
        /// Localization key for negative minute errors.
        ///
        /// - Since: 1.0.0
        static let minutes: LocalizedStringResource = "dive.kit.error.negative.minutes"
        /// Localization key for negative pressure errors.
        ///
        /// - Since: 1.0.0
        static let pressure: LocalizedStringResource = "dive.kit.error.negative.pressure"
        /// Localization key for negative volume errors.
        ///
        /// - Since: 1.0.0
        static let volume: LocalizedStringResource = "dive.kit.error.negative.volume"
        /// Localization key for negative weight errors.
        ///
        /// - Since: 1.0.0
        static let weight: LocalizedStringResource = "dive.kit.error.negative.weight"
    }
}

package extension LocalizedKey {
    /// Namespace for unit localization keys.
    ///
    /// - Since: 1.0.0
    enum Unit {}
}

package extension LocalizedKey.Unit {
    /// Namespace for rate unit localization keys.
    ///
    /// - Since: 1.0.0
    enum Rate {
        /// Localization key for rate titles.
        ///
        /// - Since: 1.0.0
        static let title: LocalizedStringResource = "dive.kit.unit.rate.title"
        /// Localization key for short rate descriptions.
        ///
        /// - Since: 1.0.0
        static let shortDescription: LocalizedStringResource = "dive.kit.unit.rate.description.short"
        /// Localization key for full rate descriptions.
        ///
        /// - Since: 1.0.0
        static let fullDescription: LocalizedStringResource = "dive.kit.unit.rate.description.full"
        /// Localization key for short rate quantities.
        ///
        /// - Since: 1.0.0
        static let shortQuantity: LocalizedStringResource = "dive.kit.unit.rate.description.short.quantity"
        /// Localization key for full rate quantities.
        ///
        /// - Since: 1.0.0
        static let fullQuantity: LocalizedStringResource = "dive.kit.unit.rate.description.full.quantity"
    }
}

package extension LocalizedKey.Unit {
    /// Namespace for depth unit localization keys.
    ///
    /// - Since: 1.0.0
    enum Depth {
        /// Localization key for depth titles.
        ///
        /// - Since: 1.0.0
        static let title: LocalizedStringResource = "dive.kit.unit.depth.title"
        /// Localization key for short imperial depth descriptions.
        ///
        /// - Since: 1.0.0
        static let shortDescriptionImperial: LocalizedStringResource = "dive.kit.unit.depth.imperial.description.short"
        /// Localization key for short metric depth descriptions.
        ///
        /// - Since: 1.0.0
        static let shortDescriptionMetric: LocalizedStringResource = "dive.kit.unit.depth.metric.description.short"
        /// Localization key for full imperial depth descriptions.
        ///
        /// - Since: 1.0.0
        static let fullDescriptionImperial: LocalizedStringResource = "dive.kit.unit.depth.imperial.description.full"
        /// Localization key for full metric depth descriptions.
        ///
        /// - Since: 1.0.0
        static let fullDescriptionMetric: LocalizedStringResource = "dive.kit.unit.depth.metric.description.full"
        /// Localization key for short imperial depth quantities.
        ///
        /// - Since: 1.0.0
        static let shortQuantityImperial: LocalizedStringResource = "dive.kit.unit.depth.imperial.description.short.quantity"
        /// Localization key for short metric depth quantities.
        ///
        /// - Since: 1.0.0
        static let shortQuantityMetric: LocalizedStringResource = "dive.kit.unit.depth.metric.description.short.quantity"
        /// Localization key for full imperial depth quantities.
        ///
        /// - Since: 1.0.0
        static let fullQuantityImperial: LocalizedStringResource = "dive.kit.unit.depth.imperial.description.full.quantity"
        /// Localization key for full metric depth quantities.
        ///
        /// - Since: 1.0.0
        static let fullQuantityMetric: LocalizedStringResource = "dive.kit.unit.depth.metric.description.full.quantity"
    }
}

package extension LocalizedKey.Unit {
    /// Namespace for mass unit localization keys.
    ///
    /// - Since: 1.0.0
    enum Mass {
        /// Localization key for mass titles.
        ///
        /// - Since: 1.0.0
        static let title: LocalizedStringResource = "dive.kit.unit.mass.title"
        /// Localization key for short imperial mass descriptions.
        ///
        /// - Since: 1.0.0
        static let shortDescriptionImperial: LocalizedStringResource = "dive.kit.unit.mass.imperial.description.short"
        /// Localization key for short metric mass descriptions.
        ///
        /// - Since: 1.0.0
        static let shortDescriptionMetric: LocalizedStringResource = "dive.kit.unit.mass.metric.description.short"
        /// Localization key for full imperial mass descriptions.
        ///
        /// - Since: 1.0.0
        static let fullDescriptionImperial: LocalizedStringResource = "dive.kit.unit.mass.imperial.description.full"
        /// Localization key for full metric mass descriptions.
        ///
        /// - Since: 1.0.0
        static let fullDescriptionMetric: LocalizedStringResource = "dive.kit.unit.mass.metric.description.full"
        /// Localization key for short imperial mass quantities.
        ///
        /// - Since: 1.0.0
        static let shortQuantityImperial: LocalizedStringResource = "dive.kit.unit.mass.imperial.description.short.quantity"
        /// Localization key for short metric mass quantities.
        ///
        /// - Since: 1.0.0
        static let shortQuantityMetric: LocalizedStringResource = "dive.kit.unit.mass.metric.description.short.quantity"
        /// Localization key for full imperial mass quantities.
        ///
        /// - Since: 1.0.0
        static let fullQuantityImperial: LocalizedStringResource = "dive.kit.unit.mass.imperial.description.full.quantity"
        /// Localization key for full metric mass quantities.
        ///
        /// - Since: 1.0.0
        static let fullQuantityMetric: LocalizedStringResource = "dive.kit.unit.mass.metric.description.full.quantity"
    }
}

package extension LocalizedKey.Unit {
    /// Namespace for volume unit localization keys.
    ///
    /// - Since: 1.0.0
    enum Volume {
        /// Localization key for volume titles.
        ///
        /// - Since: 1.0.0
        static let title: LocalizedStringResource = "dive.kit.unit.volume.title"
        /// Localization key for short imperial volume descriptions.
        ///
        /// - Since: 1.0.0
        static let shortDescriptionImperial: LocalizedStringResource = "dive.kit.unit.volume.imperial.description.short"
        /// Localization key for short metric volume descriptions.
        ///
        /// - Since: 1.0.0
        static let shortDescriptionMetric: LocalizedStringResource = "dive.kit.unit.volume.metric.description.short"
        /// Localization key for full imperial volume descriptions.
        ///
        /// - Since: 1.0.0
        static let fullDescriptionImperial: LocalizedStringResource = "dive.kit.unit.volume.imperial.description.full"
        /// Localization key for full metric volume descriptions.
        ///
        /// - Since: 1.0.0
        static let fullDescriptionMetric: LocalizedStringResource = "dive.kit.unit.volume.metric.description.full"
        /// Localization key for short imperial volume quantities.
        ///
        /// - Since: 1.0.0
        static let shortQuantityImperial: LocalizedStringResource = "dive.kit.unit.volume.imperial.description.short.quantity"
        /// Localization key for short metric volume quantities.
        ///
        /// - Since: 1.0.0
        static let shortQuantityMetric: LocalizedStringResource = "dive.kit.unit.volume.metric.description.short.quantity"
        /// Localization key for full imperial volume quantities.
        ///
        /// - Since: 1.0.0
        static let fullQuantityImperial: LocalizedStringResource = "dive.kit.unit.volume.imperial.description.full.quantity"
        /// Localization key for full metric volume quantities.
        ///
        /// - Since: 1.0.0
        static let fullQuantityMetric: LocalizedStringResource = "dive.kit.unit.volume.metric.description.full.quantity"
    }
}

package extension LocalizedKey.Unit {
    /// Namespace for pressure unit localization keys.
    ///
    /// - Since: 1.0.0
    enum Pressure {
        /// Localization key for pressure titles.
        ///
        /// - Since: 1.0.0
        static let title: LocalizedStringResource = "dive.kit.unit.pressure.title"
        /// Localization key for short imperial pressure descriptions.
        ///
        /// - Since: 1.0.0
        static let shortDescriptionImperial: LocalizedStringResource = "dive.kit.unit.pressure.imperial.description.short"
        /// Localization key for short metric pressure descriptions.
        ///
        /// - Since: 1.0.0
        static let shortDescriptionMetric: LocalizedStringResource = "dive.kit.unit.pressure.metric.description.short"
        /// Localization key for short atmosphere pressure descriptions.
        ///
        /// - Since: 1.0.0
        static let shortDescriptionAtmospheres: LocalizedStringResource = "dive.kit.unit.pressure.atmospheres.description.short"
        /// Localization key for full imperial pressure descriptions.
        ///
        /// - Since: 1.0.0
        static let fullDescriptionImperial: LocalizedStringResource = "dive.kit.unit.pressure.imperial.description.full"
        /// Localization key for full metric pressure descriptions.
        ///
        /// - Since: 1.0.0
        static let fullDescriptionMetric: LocalizedStringResource = "dive.kit.unit.pressure.metric.description.full"
        /// Localization key for full atmosphere pressure descriptions.
        ///
        /// - Since: 1.0.0
        static let fullDescriptionAtmospheres: LocalizedStringResource = "dive.kit.unit.pressure.atmospheres.description.full"
        /// Localization key for short imperial pressure quantities.
        ///
        /// - Since: 1.0.0
        static let shortQuantityImperial: LocalizedStringResource = "dive.kit.unit.pressure.imperial.description.short.quantity"
        /// Localization key for short metric pressure quantities.
        ///
        /// - Since: 1.0.0
        static let shortQuantityMetric: LocalizedStringResource = "dive.kit.unit.pressure.metric.description.short.quantity"
        /// Localization key for short atmosphere pressure quantities.
        ///
        /// - Since: 1.0.0
        static let shortQuantityAtmospheres: LocalizedStringResource = "dive.kit.unit.pressure.atmospheres.description.short.quantity"
        /// Localization key for full imperial pressure quantities.
        ///
        /// - Since: 1.0.0
        static let fullQuantityImperial: LocalizedStringResource = "dive.kit.unit.pressure.imperial.description.full.quantity"
        /// Localization key for full metric pressure quantities.
        ///
        /// - Since: 1.0.0
        static let fullQuantityMetric: LocalizedStringResource = "dive.kit.unit.pressure.metric.description.full.quantity"
        /// Localization key for full atmosphere pressure quantities.
        ///
        /// - Since: 1.0.0
        static let fullQuantityAtmospheres: LocalizedStringResource = "dive.kit.unit.pressure.atmospheres.description.full.quantity"
    }
}
