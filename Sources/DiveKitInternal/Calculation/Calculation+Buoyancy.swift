import Foundation
import DiveKitCore

package extension Calculation where Result == Buoyancy {
    /// Creates a calculation representing a buoyancy value.
    ///
    /// This convenience method wraps a raw ``Swift/Double`` buoyancy value into a
    /// ``DiveKitCore/Buoyancy`` result and associates it with the provided configuration.
    ///
    /// - Parameters:
    ///   - value: The buoyancy value.
    ///   - configuration: The calculation configuration.
    /// - Returns: A calculation containing the resulting ``DiveKitCore/Buoyancy``.
    ///
    /// ```swift
    /// let calculation = Calculation.buoyancy(
    ///     1.5,
    ///     configuration: configuration
    /// )
    /// ```
    ///
    /// - Note: Positive values indicate positive buoyancy (tendency to float),
    ///   negative values indicate negative buoyancy (tendency to sink), and
    ///   zero represents neutral buoyancy.
    /// - Since: 1.0.0
    static func buoyancy(_ value: Double, configuration: Configuration) -> Self {
        .init(result: .init(value), configuration: configuration)
    }
}
