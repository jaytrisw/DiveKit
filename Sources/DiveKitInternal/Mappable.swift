import Foundation
import DiveKitCore

/// A marker protocol that provides package-internal mapping helpers.
///
/// Types conforming to ``Mappable`` gain access to `map` functions that
/// enable transforming values in a lightweight, composable way.
///
/// Unlike standard `map` operations on collections or optionals, these methods
/// operate on the instance itself. They are used heavily in calculation
/// pipelines so validation, transformation, and typed error propagation can
/// stay in a single expression.
///
/// ```swift
/// struct Value: Mappable {
///     let number: Int
/// }
///
/// let value = Value(number: 2)
///
/// let result = try value.map { $0.number * 2 } // 4
/// ```
///
/// - Since: 1.0.0
@_marker
package protocol Mappable {}

package extension Mappable {
    /// Runs a throwing transform that does not depend on the instance.
    ///
    /// This overload is useful for chaining operations where the transformation
    /// does not require access to `self`, but should participate in the same
    /// error propagation semantics.
    ///
    /// - Parameter transform: A closure that produces a transformed value.
    /// - Returns: The result of `transform`.
    /// - Throws: The ``DiveKitCore/Error`` thrown by `transform`.
    /// - Since: 1.0.0
    func map<Transform>(
        _ transform: () throws(Error) -> Transform) throws(Error) -> Transform {
            try transform()
        }

    /// Transforms the instance using the provided closure.
    ///
    /// This method passes `self` into the transformation closure, allowing
    /// inline, composable transformations without introducing intermediate variables.
    ///
    /// - Parameter transform: A closure that transforms `self`.
    /// - Returns: The result of applying `transform` to `self`.
    /// - Throws: The ``DiveKitCore/Error`` thrown by `transform`.
    ///
    /// ```swift
    /// let value = 2
    /// let result = try value.map { $0 * 3 } // 6
    /// ```
    ///
    /// - Since: 1.0.0
    func map<Transform>(
        _ transform: (Self) throws(Error) -> Transform) throws(Error) -> Transform {
            try transform(self)
        }
}

/// Enables internal mapping helpers on blends.
///
/// - Since: 1.0.0
extension Blend: Mappable {}
/// Enables internal mapping helpers on buoyancy values.
///
/// - Since: 1.0.0
extension Buoyancy: Mappable {}
/// Enables internal mapping helpers on calculations.
///
/// - Since: 1.0.0
extension Calculation: Mappable {}
/// Enables internal mapping helpers on raw decimal values.
///
/// - Since: 1.0.0
extension Double: Mappable {}
/// Enables internal mapping helpers on physical objects.
///
/// - Since: 1.0.0
extension Object: Mappable {}
/// Enables internal mapping helpers on fractional pressures.
///
/// - Since: 1.0.0
extension FractionalPressure: Mappable {}
/// Enables internal mapping helpers on partial pressures.
///
/// - Since: 1.0.0
extension PartialPressure: Mappable {}
/// Enables internal mapping helpers on tanks.
///
/// - Since: 1.0.0
extension Tank: Mappable {}
/// Enables internal mapping helpers on internal tuples.
///
/// - Since: 1.0.0
extension Tuple: Mappable {}
