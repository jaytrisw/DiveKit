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

        /// A tracked gas's half-time has no coefficients in a decompression model.
        ///
        /// - Since: 1.0.0
        case unmodeled(_ gas: any GasRepresentable)
    }
}

/// Allows gas payloads to be compared by gas identity.
///
/// - Since: 1.0.0
extension Error.Gas: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
            case let (.metabolic(lhs), .metabolic(rhs)): AnyGas(lhs) == AnyGas(rhs)
            case let (.unmodeled(lhs), .unmodeled(rhs)): AnyGas(lhs) == AnyGas(rhs)
            case (.metabolic, _), (.unmodeled, _): false
        }
    }
}
