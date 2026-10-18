import Foundation
import DiveKitCore

package extension BuoyancyCalculating {
    /// Calculates the buoyancy of an object in water using the provided configuration.
    ///
    /// Buoyancy is the weight of the displaced water compared with the object's
    /// weight.
    ///
    /// Before performing the calculation, the object's weight and volume are validated
    /// to ensure they are nonnegative.
    ///
    /// - Parameters:
    ///   - object: The object whose buoyancy is being calculated.
    ///   - configuration: The calculation configuration, including unit and water settings.
    ///   - callSite: The location where the calculation is requested.
    ///
    /// - Returns: A ``DiveKitCore/Calculation`` containing the resulting ``DiveKitCore/Buoyancy``.
    ///
    /// - Throws: ``DiveKitCore/Error/negative(_:_:)`` if the object's weight or volume
    ///   is negative, or ``DiveKitCore/Error/range(_:_:)`` if the object's weight or
    ///   volume, the water model's weight, or the displaced water's weight is not
    ///   finite, or if the water model's weight is not greater than zero.
    ///
    /// ```swift
    /// let result = try calculator.buoyancy(
    ///     of: object,
    ///     with: configuration,
    ///     callSite)
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
            let waterWeight = try configuration.waterWeight(callSite)
            return try object.weight
                .validatedFiniteNonNegative(callSite)
                .map { (_: Mass) throws(Error) in
                    try object.volume
                        .validatedFiniteNonNegative(callSite)
                }
                .map { $0.value * waterWeight }
                .validatedFinite(callSite)
                .map { $0 - object.weight.value }
                .map { .buoyancy($0, configuration: configuration) }
        }
}
