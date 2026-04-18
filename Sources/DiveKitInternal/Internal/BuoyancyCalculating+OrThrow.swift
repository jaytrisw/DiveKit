import Foundation
import DiveKitCore

package extension BuoyancyCalculating {
    /// Calculates the buoyancy of an object in water using the provided configuration.
    ///
    /// This method determines buoyancy by comparing the weight of the displaced water
    /// with the object's weight.
    ///
    /// Before performing the calculation, the object's weight and volume are validated
    /// to ensure they are non-negative.
    ///
    /// - Parameters:
    ///   - object: The object whose buoyancy is being calculated.
    ///   - configuration: The calculation configuration, including unit and water settings.
    ///   - callSite: The location where the calculation is requested.
    ///
    /// - Returns: A ``DiveKitCore/Calculation`` containing the resulting ``DiveKitCore/Buoyancy``.
    ///
    /// - Throws: ``DiveKitCore/Error/negative(_:_:)`` if the object's weight or volume
    ///   is negative.
    ///
    /// ```swift
    /// let result = try calculator.buoyancy(
    ///     of: object,
    ///     with: configuration,
    ///     callSite
    /// )
    /// ```
    ///
    /// - Note: Positive buoyancy indicates the object tends to float, negative
    ///   buoyancy indicates it tends to sink, and neutral buoyancy indicates
    ///   equilibrium.
    /// - Since: 1.0.0
    func buoyancy(
        of object: Object,
        with configuration: Configuration,
        _ callSite: CallSite) throws(Error) -> Calculation<Buoyancy> {
            try object.weight.validate(using: .nonNegative, orThrow: { .negative($0, callSite) })
                .map { (_: Mass) throws(Error) in
                    try object.volume.validate(using: .nonNegative, orThrow: { .negative($0, callSite) })
                }
                .map { object.volume.value * configuration.water.weight(configuration.units).value }
                .map { $0 - object.weight.value }
                .map { .buoyancy($0, configuration: configuration) }
        }
}
