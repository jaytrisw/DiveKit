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
        /// A gas was added to a blend that already contains it.
        ///
        /// - Since: 1.0.0
        case gasAlreadyPresent(_ gas: any GasRepresentable, _ blend: DiveKitCore.Blend<Unblended>)
        /// A gas was updated in a blend that does not contain it.
        ///
        /// - Since: 1.0.0
        case gasNotPresent(_ gas: any GasRepresentable, _ blend: DiveKitCore.Blend<Unblended>)
    }
}

/// Allows blend error payloads to be compared, with gases compared by identity.
///
/// - Since: 1.0.0
extension Error.Blend: Equatable {
    /// Returns whether two blend payloads have the same case, values and gas identity.
    ///
    /// - Parameters:
    ///   - lhs: The first payload.
    ///   - rhs: The second payload.
    /// - Returns: `true` when both cases and all of their values match.
    /// - Since: 1.0.0
    public static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
            case let (.totalPressure(lhs, lhsBlend), .totalPressure(rhs, rhsBlend)),
                 let (.pressureRange(lhs, lhsBlend), .pressureRange(rhs, rhsBlend)):
                lhs == rhs && lhsBlend == rhsBlend
            case let (.gasAlreadyPresent(lhs, lhsBlend), .gasAlreadyPresent(rhs, rhsBlend)),
                 let (.gasNotPresent(lhs, lhsBlend), .gasNotPresent(rhs, rhsBlend)):
                AnyGas(lhs) == AnyGas(rhs) && lhsBlend == rhsBlend
            case (.totalPressure, _), (.pressureRange, _), (.gasAlreadyPresent, _), (.gasNotPresent, _):
                false
        }
    }
}
