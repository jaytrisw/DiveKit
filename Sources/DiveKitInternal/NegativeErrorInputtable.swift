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
    /// - Returns: A ``DiveKitCore/Error/negative(_:_:)`` value for the given input.
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
/// type-safe ``DiveKitCore/Error/negative(_:_:)`` construction across domain values.
///
/// - Since: 1.0.0
package protocol NegativeErrorInputtable {
    /// Returns a representation of the value suitable for a negative input error.
    ///
    /// - Returns: An ``DiveKitCore/Error/Negative`` describing this value.
    /// - Since: 1.0.0
    func negativeInput() -> Error.Negative
}

/// Maps ``DiveKitCore/Depth`` values into negative-depth errors.
///
/// - Since: 1.0.0
extension Depth: NegativeErrorInputtable {
    /// Returns a negative input representation for a ``DiveKitCore/Depth`` value.
    ///
    /// - Since: 1.0.0
    package func negativeInput() -> Error.Negative {
        .depth(self)
    }
}

/// Maps ``DiveKitCore/Volume`` values into negative-volume errors.
///
/// - Since: 1.0.0
extension Volume: NegativeErrorInputtable {
    /// Returns a negative input representation for a ``DiveKitCore/Volume`` value.
    ///
    /// - Since: 1.0.0
    package func negativeInput() -> Error.Negative {
        .volume(self)
    }
}

/// Maps ``DiveKitCore/Mass`` values into negative-weight errors.
///
/// - Since: 1.0.0
extension Mass: NegativeErrorInputtable {
    /// Returns a negative input representation for a ``DiveKitCore/Mass`` value.
    ///
    /// - Since: 1.0.0
    package func negativeInput() -> Error.Negative {
        .weight(self)
    }
}

/// Maps ``DiveKitCore/Pressure`` values into negative-pressure errors.
///
/// - Since: 1.0.0
extension Pressure: NegativeErrorInputtable {
    /// Returns a negative input representation for a ``DiveKitCore/Pressure`` value.
    ///
    /// - Since: 1.0.0
    package func negativeInput() -> Error.Negative {
        .pressure(self)
    }
}

/// Maps ``DiveKitCore/FractionalPressure`` values into negative-fractional-pressure errors.
///
/// - Since: 1.0.0
extension FractionalPressure: NegativeErrorInputtable {
    /// Returns a negative input representation for a ``DiveKitCore/FractionalPressure`` value.
    ///
    /// - Since: 1.0.0
    package func negativeInput() -> Error.Negative {
        .fractionalPressure(value)
    }
}

/// Maps ``DiveKitCore/PartialPressure`` values into negative-partial-pressure errors.
///
/// - Since: 1.0.0
extension PartialPressure: NegativeErrorInputtable {
    /// Returns a negative input representation for a ``DiveKitCore/PartialPressure`` value.
    ///
    /// - Since: 1.0.0
    package func negativeInput() -> Error.Negative {
        .partialPressure(value)
    }
}

/// Maps ``DiveKitCore/Minutes`` values into negative-minutes errors.
///
/// - Since: 1.0.0
extension Minutes: NegativeErrorInputtable {
    /// Returns a negative input representation for a ``DiveKitCore/Minutes`` value.
    ///
    /// - Since: 1.0.0
    package func negativeInput() -> Error.Negative {
        .minutes(self)
    }
}
