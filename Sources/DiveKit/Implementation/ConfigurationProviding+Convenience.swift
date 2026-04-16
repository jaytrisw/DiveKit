import Foundation
import DiveKitCore

public extension ConfigurationProviding {
    /// Creates a conforming type using units and water configuration.
    ///
    /// This convenience initializer constructs a `Configuration` from the provided
    /// `units` and `water`, then forwards it to the designated initializer.
    ///
    /// - Parameters:
    ///   - units: The unit system used for calculations.
    ///   - water: The water configuration used for density and pressure calculations.
    ///
    /// ```swift
    /// let calculator = BuoyancyCalculator(
    ///     .metric,
    ///     water: .salt
    /// )
    /// ```
    ///
    /// - Note: This initializer is available for all types conforming to
    ///   `ConfigurationProviding` that implement `init(configuration:)`.
    /// - Since: 1.0.0
    init(_ units: Units, water: Water) {
        self.init(configuration: .init(units: units, water: water))
    }
}
