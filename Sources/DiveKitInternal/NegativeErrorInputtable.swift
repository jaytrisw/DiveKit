import Foundation
import DiveKitCore

package extension Error {
    /// Creates a domain error for a negative numeric input.
    ///
    /// This method allows domain-specific types to provide a strongly-typed
    /// representation of invalid negative inputs while centralizing error creation.
    ///
    /// - Parameters:
    ///   - value: A value capable of producing a corresponding negative input representation.
    ///   - callSite: The location where the error originated.
    /// - Returns: A `DiveKitCore.Error.negative` value for the given input.
    /// - Since: 1.0.0
    static func negative<E: NegativeErrorInputtable>(
        _ value: E,
        _ callSite: CallSite) -> Self {
            .negative(value.negativeInput(), callSite)
        }
}

/// A type that can describe itself as a negative input error payload.
///
/// Conforming types define how they should be represented when used as the
/// source of a negative input validation failure. This enables consistent,
/// type-safe `DiveKitCore.Error.negative` construction across domain values.
///
/// - Since: 1.0.0
package protocol NegativeErrorInputtable {
    /// Returns a representation of the value suitable for a negative input error.
    ///
    /// - Returns: An `Error.Negative` describing this value.
    /// - Since: 1.0.0
    func negativeInput() -> Error.Negative
}

/// Maps `Depth` values into negative-depth errors.
///
/// - Since: 1.0.0
extension Depth: NegativeErrorInputtable {
    /// Returns a negative input representation for a `Depth` value.
    ///
    /// - Since: 1.0.0
    package func negativeInput() -> Error.Negative {
        .depth(self)
    }
}

/// Maps `Volume` values into negative-volume errors.
///
/// - Since: 1.0.0
extension Volume: NegativeErrorInputtable {
    /// Returns a negative input representation for a `Volume` value.
    ///
    /// - Since: 1.0.0
    package func negativeInput() -> Error.Negative {
        .volume(self)
    }
}

/// Maps `Mass` values into negative-weight errors.
///
/// - Since: 1.0.0
extension Mass: NegativeErrorInputtable {
    /// Returns a negative input representation for a `Mass` value.
    ///
    /// - Since: 1.0.0
    package func negativeInput() -> Error.Negative {
        .weight(self)
    }
}

/// Maps `Pressure` values into negative-pressure errors.
///
/// - Since: 1.0.0
extension Pressure: NegativeErrorInputtable {
    /// Returns a negative input representation for a `Pressure` value.
    ///
    /// - Since: 1.0.0
    package func negativeInput() -> Error.Negative {
        .pressure(self)
    }
}

/// Maps `FractionalPressure` values into negative-fractional-pressure errors.
///
/// - Since: 1.0.0
extension FractionalPressure: NegativeErrorInputtable {
    /// Returns a negative input representation for a `FractionalPressure` value.
    ///
    /// - Since: 1.0.0
    package func negativeInput() -> Error.Negative {
        .fractionalPressure(value)
    }
}

/// Maps `PartialPressure` values into negative-partial-pressure errors.
///
/// - Since: 1.0.0
extension PartialPressure: NegativeErrorInputtable {
    /// Returns a negative input representation for a `PartialPressure` value.
    ///
    /// - Since: 1.0.0
    package func negativeInput() -> Error.Negative {
        .partialPressure(value)
    }
}

/// Maps `Minutes` values into negative-minutes errors.
///
/// - Since: 1.0.0
extension Minutes: NegativeErrorInputtable {
    /// Returns a negative input representation for a `Minutes` value.
    ///
    /// - Since: 1.0.0
    package func negativeInput() -> Error.Negative {
        .minutes(self)
    }
}
