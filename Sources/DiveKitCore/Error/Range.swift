import Foundation

public extension Error {
    /// Payloads for range validation errors.
    ///
    /// - Since: 1.0.0
    enum Range: Sendable {
        /// A value was below the expected lower bound.
        ///
        /// - Since: 1.0.0
        case lowerBound(_ provided: Double, _ expected: Double)
        /// A value was above the expected upper bound.
        ///
        /// - Since: 1.0.0
        case upperBound(_ provided: Double, _ expected: Double)
    }
}

/// Allows range payloads to be compared.
///
/// - Since: 1.0.0
extension Error.Range: Equatable {}
