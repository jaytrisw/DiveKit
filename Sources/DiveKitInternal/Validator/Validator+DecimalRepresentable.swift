import Foundation

package extension Validator where Value: DecimalRepresentable {
    /// A validator that succeeds when the value is greater than or equal to zero.
    ///
    /// This is commonly used to enforce that domain values representing
    /// quantities, such as depth, pressure, or time, are not negative.
    ///
    /// - Returns: A validator that returns `true` if the value is greater than
    ///   or equal to `.zero`.
    ///
    /// ```swift
    /// let isValid = Validator<Depth>.nonNegative
    /// isValid.validate(10)  // true
    /// isValid.validate(-1)  // false
    /// ```
    ///
    /// - Since: 1.0.0
    static var nonNegative: Self {
        .init { $0 >= .zero }
    }

    /// Returns a validator that succeeds when the value is strictly greater than a bound.
    ///
    /// - Parameter bound: The lower bound that values must exceed.
    /// - Returns: A validator that returns `true` if the value is greater than `bound`.
    ///
    /// ```swift
    /// let isGreaterThanTen = Validator<Depth>.greater(than: 10)
    /// isGreaterThanTen.validate(15) // true
    /// isGreaterThanTen.validate(5)  // false
    /// ```
    ///
    /// - Since: 1.0.0
    static func greater(than bound: Value) -> Self {
        .init { $0 > bound }
    }
}
