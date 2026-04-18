import Foundation
import DiveKitCore

/// A reusable validation rule for a value.
///
/// ``Validator`` is a small wrapper around a predicate. Calculation code combines
/// validators before converting failures into typed ``DiveKitCore/Error`` values
/// with ``Validatable/validate(using:orThrow:)``.
///
/// ```swift
/// let isPositive = Validator<Double>.greater(than: 0)
/// let isLessThanTen = Validator<Double>.less(than: 10)
///
/// let isValid = isPositive.or(isLessThanTen)
/// isValid.validate(5) // true
/// ```
///
/// - Since: 1.0.0
package struct Validator<Value> {
    /// A closure that evaluates whether a value is valid.
    ///
    /// - Since: 1.0.0
    package let validate: (Value) -> Bool

    /// Creates a new validator with the provided validation logic.
    ///
    /// - Parameter validate: A closure that returns `true` if the value is valid,
    ///   or `false` otherwise.
    /// - Since: 1.0.0
    package init(validate: @escaping (Value) -> Bool) {
        self.validate = validate
    }
}

package extension Validator {
    /// Returns a validator that succeeds if either validator succeeds.
    ///
    /// This method composes two validators using logical OR semantics, allowing
    /// values that satisfy at least one condition to pass validation.
    ///
    /// - Parameter other: Another validator to combine with.
    /// - Returns: A new validator that returns `true` if either validator returns `true`.
    ///
    /// ```swift
    /// let isZero = Validator<Int> { $0 == 0 }
    /// let isPositive = Validator<Int> { $0 > 0 }
    ///
    /// let nonNegative = isZero.or(isPositive)
    /// nonNegative.validate(0) // true
    /// nonNegative.validate(5) // true
    /// nonNegative.validate(-1) // false
    /// ```
    ///
    /// - Since: 1.0.0
    func or(_ other: Validator) -> Self {
        .init {
            validate($0) || other.validate($0)
        }
    }
}
