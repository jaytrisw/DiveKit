import Foundation
import DiveKitCore

/// A marker protocol that enables validation through ``Validator``.
///
/// Types conforming to ``Validatable`` gain access to validation utilities that
/// enforce constraints and throw typed ``DiveKitCore/Error`` values when those
/// constraints fail.
///
/// - Since: 1.0.0
package protocol Validatable {}

package extension Validatable {
    /// Validates the instance using the provided validator.
    ///
    /// This method allows domain types to enforce invariants in a composable
    /// way while keeping error construction flexible and context-aware.
    ///
    /// - Parameters:
    ///   - validator: A ``Validator`` that determines whether the value is valid.
    ///   - error: A closure that produces the domain error when validation fails.
    /// - Returns: The validated instance (`self`) if validation succeeds.
    /// - Throws: The ``DiveKitCore/Error`` returned by `error` if validation fails.
    ///
    /// ```swift
    /// try depth.validate(using: .nonNegative) {
    ///     .negative($0, callSite)
    /// }
    /// ```
    ///
    /// - Note: This method returns `self` to support fluent chaining of validation
    ///   and transformation operations.
    /// - Since: 1.0.0
    @discardableResult
    func validate(
        using validator: Validator<Self>,
        orThrow error: (Self) -> Error) throws(Error) -> Self {
            guard validator.validate(self) else {
                throw error(self)
            }
            return self
        }
}

/// Makes ``Swift/Double`` values validatable by internal helpers.
///
/// - Since: 1.0.0
extension Double: Validatable {}
/// Makes ``DiveKitCore/Depth`` values validatable by internal helpers.
///
/// - Since: 1.0.0
extension Depth: Validatable {}
