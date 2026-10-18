import Foundation

public extension Error {
    /// Payloads for gas validation errors.
    ///
    /// - Since: 1.0.0
    enum Gas: Sendable {
        /// A metabolic gas was provided where only an inert gas is valid.
        ///
        /// - Since: 1.0.0
        case metabolic(_ gas: any GasRepresentable)

        /// No decompression table row has coefficients for a tracked gas at its
        /// half-time, or none shared with the compartment's other tracked gases.
        ///
        /// - Since: 1.0.0
        case unmodeled(_ gas: any GasRepresentable)
    }
}

/// Allows gas payloads to be compared by gas identity.
///
/// - Since: 1.0.0
extension Error.Gas: Equatable {
    /// Returns whether two gas payloads have the same case and gas identity.
    ///
    /// - Parameters:
    ///   - lhs: The first payload.
    ///   - rhs: The second payload.
    /// - Returns: `true` when both cases match and wrap the same gas.
    /// - Since: 1.0.0
    public static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
            case let (.metabolic(lhs), .metabolic(rhs)): AnyGas(lhs) == AnyGas(rhs)
            case let (.unmodeled(lhs), .unmodeled(rhs)): AnyGas(lhs) == AnyGas(rhs)
            case (.metabolic, _), (.unmodeled, _): false
        }
    }
}
