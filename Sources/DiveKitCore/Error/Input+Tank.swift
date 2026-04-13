import Foundation

public extension Error {
    /// Payloads for tank validation errors.
    ///
    /// - Since: 1.0.0
    enum Tank: Sendable {
        /// The tank's rated pressure was invalid.
        ///
        /// - Since: 1.0.0
        case ratedPressure(_ pressure: Pressure, _ tank: DiveKitCore.Tank)
        /// The tank's volume was invalid.
        ///
        /// - Since: 1.0.0
        case volume(_ volume: Volume, _ tank: DiveKitCore.Tank)

    }
}

/// Allows tank error payloads to be compared.
///
/// - Since: 1.0.0
extension Error.Tank: Equatable {}
