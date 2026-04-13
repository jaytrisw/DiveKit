import Foundation
import DiveKitCore

package extension Buoyancy {
    /// Creates a buoyancy value from a raw numeric input.
    ///
    /// This initializer interprets the sign of `value` to determine the buoyancy state:
    /// negative values produce `.negative`, positive values produce `.positive`,
    /// and zero produces `.neutral`.
    ///
    /// - Parameter value: The raw buoyancy value.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let positive = Buoyancy(2.0)   // .positive(2.0)
    /// let negative = Buoyancy(-1.5)  // .negative(1.5)
    /// let neutral  = Buoyancy(0.0)   // .neutral
    /// ```
    ///
    /// - Note: The magnitude of negative values is converted to a positive
    ///   associated value using `abs(_:)`.
    /// - Since: 1.0.0
    init(_ value: Double) {
        if value < 0 {
            self = .negative(abs(value))
            return
        }

        if value > 0 {
            self = .positive(value)
            return
        }
        self = .neutral
    }
}
