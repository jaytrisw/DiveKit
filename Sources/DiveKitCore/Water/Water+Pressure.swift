import Foundation

public extension Water {
    /// A water pressure model.
    ///
    /// `Pressure` stores how much depth is required to increase pressure by one
    /// atmosphere in a particular water model.
    ///
    /// - Since: 1.0.0
    struct Pressure: Sendable {
        /// The depth increase equivalent to one atmosphere of pressure.
        ///
        /// - Since: 1.0.0
        public let increase: Increase

        /// Creates a water pressure model.
        ///
        /// - Parameter increase: The depth increase equivalent to one atmosphere.
        /// - Since: 1.0.0
        public init(increase: Increase) {
            self.increase = increase
        }
    }
}

public extension Water.Pressure {
    /// A depth interval that corresponds to one atmosphere of pressure.
    ///
    /// - Since: 1.0.0
    struct Increase: Sendable {
        /// The numeric depth interval.
        ///
        /// - Since: 1.0.0
        public let value: Double

        /// The depth unit for `value`.
        ///
        /// - Since: 1.0.0
        public let unit: Depth.Unit

        /// Creates a pressure increase.
        ///
        /// - Parameters:
        ///   - value: The numeric depth interval.
        ///   - unit: The depth unit for `value`.
        /// - Since: 1.0.0
        public init(value: Double, unit: Depth.Unit) {
            self.value = value
            self.unit = unit
        }

        /// Creates a pressure increase using the depth unit for a unit system.
        ///
        /// - Parameters:
        ///   - value: The numeric depth interval.
        ///   - units: The unit system that supplies the depth unit.
        /// - Since: 1.0.0
        public init(_ value: Double, units: Units) {
            self.init(value: value, unit: units.depth)
        }
    }
}

/// Allows water pressure models to be compared.
///
/// - Since: 1.0.0
extension Water.Pressure: Equatable {}
/// Allows pressure increases to be compared.
///
/// - Since: 1.0.0
extension Water.Pressure.Increase: Equatable {}
