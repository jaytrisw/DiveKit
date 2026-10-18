import Foundation
import DiveKitCore

package extension Double {
    /// Returns the value if it is finite.
    ///
    /// - Parameter callSite: The call site attached to the error.
    /// - Returns: The value, unchanged.
    /// - Throws: `Error.range(.upperBound(value, .greatestFiniteMagnitude))` if
    ///   the value is infinite or NaN.
    /// - Since: 1.0.0
    @discardableResult
    func validatedFinite(_ callSite: CallSite) throws(Error) -> Self {
        try validate(using: .finite) { .range(.upperBound($0, .greatestFiniteMagnitude), callSite) }
    }
}

package extension DecimalRepresentable {
    /// Returns the value if it is finite.
    ///
    /// - Parameter callSite: The call site attached to the error.
    /// - Returns: The value, unchanged.
    /// - Throws: `Error.range(.upperBound(value, .greatestFiniteMagnitude))` if
    ///   the value is infinite or NaN.
    /// - Since: 1.0.0
    @discardableResult
    func validatedFinite(_ callSite: CallSite) throws(Error) -> Self {
        try validate(using: .finite) { .range(.upperBound($0.value, .greatestFiniteMagnitude), callSite) }
    }
}

package extension DecimalRepresentable where Self: NegativeErrorInputtable {
    /// Returns the value if it is finite and not negative, checking finiteness first.
    ///
    /// - Parameter callSite: The call site attached to the error.
    /// - Returns: The value, unchanged.
    /// - Throws: `Error.range(.upperBound(value, .greatestFiniteMagnitude))` if
    ///   the value is infinite or NaN, or `Error.negative` if it is negative.
    /// - Since: 1.0.0
    @discardableResult
    func validatedFiniteNonNegative(_ callSite: CallSite) throws(Error) -> Self {
        try validatedFinite(callSite)
            .validate(using: .nonNegative) { .negative($0, callSite) }
    }
}
