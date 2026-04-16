import Foundation

package extension Validator where Value == Double {
    /// Returns a validator that succeeds when the value is within a closed range.
    ///
    /// - Parameters:
    ///   - lower: The lower bound, inclusive.
    ///   - upper: The upper bound, inclusive.
    /// - Returns: A validator that returns `true` if the value is between `lower` and `upper`.
    ///
    /// ```swift
    /// let validator = Validator<Double>.between(0, and: 1)
    /// validator.validate(0.5) // true
    /// validator.validate(1.5) // false
    /// ```
    ///
    /// - Since: 1.0.0
    static func between(_ lower: Value, and upper: Value) -> Self {
        .init { $0 >= lower && $0 <= upper }
    }

    /// Returns a validator that succeeds when the value is strictly greater than a bound.
    ///
    /// - Parameter bound: The lower bound that values must exceed.
    /// - Returns: A validator that returns `true` if the value is greater than `bound`.
    ///
    /// ```swift
    /// Validator<Double>.greater(than: 0).validate(1) // true
    /// ```
    ///
    /// - Since: 1.0.0
    static func greater(than bound: Value) -> Self {
        .init { $0 > bound }
    }

    /// Returns a validator that succeeds when the value is strictly less than a bound.
    ///
    /// - Parameter bound: The upper bound that values must be less than.
    /// - Returns: A validator that returns `true` if the value is less than `bound`.
    ///
    /// ```swift
    /// Validator<Double>.less(than: 1).validate(0.5) // true
    /// ```
    ///
    /// - Since: 1.0.0
    static func less(than bound: Value) -> Self {
        .init { $0 < bound }
    }

    /// Returns a validator that succeeds when the value is equal to another value.
    ///
    /// - Parameter other: The value to compare against.
    /// - Returns: A validator that returns `true` if the value is equal to `other`.
    ///
    /// ```swift
    /// Validator<Double>.equal(to: 1).validate(1) // true
    /// ```
    ///
    /// - Since: 1.0.0
    static func equal(to other: Value) -> Self {
        .init { $0 == other }
    }
}

package extension Validator where Value == Double {
    /// Returns a validator that succeeds when the value is greater than or equal to a bound.
    ///
    /// This is composed from ``Validator/greater(than:)`` and ``Validator/equal(to:)``.
    ///
    /// - Parameter bound: The lower bound, inclusive.
    /// - Returns: A validator that returns `true` if the value is greater than or equal to `bound`.
    /// - Since: 1.0.0
    static func greaterThanOrEqual(to bound: Value) -> Self {
        .greater(than: bound).or(.equal(to: bound))
    }

    /// Returns a validator that succeeds when the value is less than or equal to a bound.
    ///
    /// This is composed from ``Validator/less(than:)`` and ``Validator/equal(to:)``.
    ///
    /// - Parameter bound: The upper bound, inclusive.
    /// - Returns: A validator that returns `true` if the value is less than or equal to `bound`.
    /// - Since: 1.0.0
    static func lessThanOrEqual(to bound: Value) -> Self {
        .less(than: bound).or(.equal(to: bound))
    }
}

package extension Double {
    /// A constant representing the value `1`.
    ///
    /// This is commonly used in normalized domains, such as fractional values,
    /// where `1` represents a complete quantity.
    ///
    /// - Since: 1.0.0
    static let one: Self = 1
}
