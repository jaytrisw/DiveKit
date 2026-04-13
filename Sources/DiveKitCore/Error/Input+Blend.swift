import Foundation

public extension Error {
    /// Payloads for blend validation errors.
    ///
    /// - Since: 1.0.0
    enum Blend: Sendable {
        /// The blend's total fractional pressure did not satisfy the expected invariant.
        ///
        /// - Since: 1.0.0
        case totalPressure(_ totalPressure: Double, _ blend: DiveKitCore.Blend<Unblended>)
        /// A component fractional pressure was outside the valid range.
        ///
        /// - Since: 1.0.0
        case pressureRange(_ pressureRange: Double, _ blend: DiveKitCore.Blend<Unblended>)
    }
}

/// Allows blend error payloads to be compared.
///
/// - Since: 1.0.0
extension Error.Blend: Equatable {}
