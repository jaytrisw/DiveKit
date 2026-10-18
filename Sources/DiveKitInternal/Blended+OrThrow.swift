import Foundation
import DiveKitCore

package extension Blend where State == Unblended {
    /// The largest difference from `1` that a blend's total pressure may have.
    ///
    /// Floating-point sums of whole-percent fractions can miss `1` by one unit in
    /// the last place, such as `0.18 + 0.47 + 0.35 == 0.9999999999999999`. This
    /// tolerance accepts that rounding but no real shortfall.
    ///
    /// - Since: 1.0.0
    static var totalPressureTolerance: Double { 1e-12 }

    /// Validates and converts an unblended gas mixture into a blended state.
    ///
    /// The total pressure of the mixture must equal `1`, within
    /// ``totalPressureTolerance``.
    ///
    /// - Parameter callSite: The location where the blend operation is performed.
    /// - Returns: A new ``DiveKitCore/Blend`` in the ``DiveKitCore/Blended`` state.
    /// - Throws: ``DiveKitCore/Error/blend(_:_:)`` if the total pressure is not within
    ///   ``totalPressureTolerance`` of `1`.
    ///
    /// ```swift
    /// let blended = try unblendedBlend.blend(callSite)
    /// ```
    ///
    /// - Since: 1.0.0
    func blend(_ callSite: CallSite) throws(Error) -> Blend<Blended> {
        try totalPressure.validate(using: .approximatelyEqual(to: .one, tolerance: Self.totalPressureTolerance)) {
            .blend(.totalPressure($0, self), callSite)
        }
        return .init(self)
    }
}
