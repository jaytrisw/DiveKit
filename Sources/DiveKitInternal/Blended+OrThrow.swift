import Foundation
import DiveKitCore

package extension Blend where State == Unblended {
    /// Validates and converts an unblended gas mixture into a blended state.
    ///
    /// This method validates that the total pressure of the mixture is equal to `1`
    /// before allowing the transition to a `Blended` state. This ensures the mixture
    /// represents a fully normalized composition.
    ///
    /// - Parameter callSite: The location where the blend operation is performed.
    /// - Returns: A new `Blend` in the `Blended` state.
    /// - Throws: `DiveKitCore.Error.blend` if the total pressure is not equal to `1`.
    ///
    /// ## Invariant
    ///
    /// - The sum of all component pressures must equal `1`.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let blended = try unblendedBlend.blend(callSite)
    /// ```
    ///
    /// - Note: This method enforces a strict validation step to prevent invalid
    ///   blended states from being created.
    /// - Since: 1.0.0
    func blend(_ callSite: CallSite) throws(Error) -> Blend<Blended> {
        try totalPressure.validate(using: .equal(to: .one)) {
            .blend(.totalPressure($0, self), callSite)
        }
        return .init(self)
    }
}
