import Foundation

/// The unit and water model used by DiveKit calculations.
///
/// `Configuration` determines how domain values are interpreted and which
/// water density and pressure model a calculator uses.
///
/// - Since: 1.0.0
public struct Configuration: Sendable {
    /// The unit system used for calculation results.
    ///
    /// - Since: 1.0.0
    public let units: Units

    /// The water model used for density and pressure calculations.
    ///
    /// - Since: 1.0.0
    public let water: Water

    /// Creates a calculation configuration.
    ///
    /// - Parameters:
    ///   - units: The unit system used for calculation results.
    ///   - water: The water model used for density and pressure calculations.
    /// - Since: 1.0.0
    public init(units: Units, water: Water) {
        self.units = units
        self.water = water
    }
}

/// Allows configurations to be compared by their effective units and water values.
///
/// - Since: 1.0.0
extension Configuration: Equatable {
    /// Returns whether two configurations are effectively equivalent.
    ///
    /// Water closures are compared by evaluating their weight and pressure for
    /// the right-hand configuration's unit system.
    ///
    /// - Parameters:
    ///   - lhs: The first configuration.
    ///   - rhs: The second configuration.
    /// - Returns: `true` when the unit system and effective water values match.
    /// - Since: 1.0.0
    public static func == (lhs: Configuration, rhs: Configuration) -> Bool {
        rhs.units == lhs.units &&
        rhs.water.weight(rhs.units) == lhs.water.weight(rhs.units) &&
        rhs.water.pressure(rhs.units) == lhs.water.pressure(rhs.units)
    }
}
