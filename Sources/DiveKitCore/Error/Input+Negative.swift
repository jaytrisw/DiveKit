import Foundation

public extension Error {
    /// Payloads for negative input errors.
    ///
    /// - Since: 1.0.0
    enum Negative: Sendable {
        /// A negative depth was provided.
        ///
        /// - Since: 1.0.0
        case depth(_ depth: Depth)
        /// A negative fractional pressure was provided.
        ///
        /// - Since: 1.0.0
        case fractionalPressure(_ fractionalPressure: Double)
        /// A negative partial pressure was provided.
        ///
        /// - Since: 1.0.0
        case partialPressure(_ partialPressure: Double)
        /// A negative duration was provided.
        ///
        /// - Since: 1.0.0
        case minutes(_ minutes: Minutes)
        /// A negative pressure was provided.
        ///
        /// - Since: 1.0.0
        case pressure(_ pressure: Pressure)
        /// A negative volume was provided.
        ///
        /// - Since: 1.0.0
        case volume(_ volume: Volume)
        /// A negative weight was provided.
        ///
        /// - Since: 1.0.0
        case weight(_ weight: Mass)
    }
}

/// Allows negative input payloads to be compared.
///
/// - Since: 1.0.0
extension Error.Negative: Equatable {}
