import Foundation
import DiveKitCore

/// A shorthand for numeric literal conformances used by decimal wrappers.
///
/// - Since: 1.0.0
package typealias ExpressibleBy = ExpressibleByFloatLiteral & ExpressibleByIntegerLiteral

/// A package-internal contract for domain values backed by a `Double`.
///
/// `DecimalRepresentable` gives DiveKit's decimal domain wrappers a common
/// comparison, literal, validation, and mapping surface while preserving the
/// stronger type information of values such as `Depth`, `Pressure`, and
/// `Volume`.
///
/// Conforming types must provide a stored or computed `value` and an
/// initializer that accepts a `Double`. Default implementations are provided
/// for literal initialization and comparison.
///
/// ## Example
///
/// ```swift
/// struct Depth: DecimalRepresentable {
///     let value: Double
///
///     init(_ value: Double) {
///         self.value = value
///     }
/// }
///
/// let depth: Depth = 10
/// let isShallower = depth < 20
/// ```
///
/// - Note: Conforming types are expected to enforce any domain-specific
///   invariants (such as valid ranges) within their initializer or through
///   `Validatable` conformance.
/// - Since: 1.0.0
package protocol DecimalRepresentable: Equatable, Hashable, Comparable, ExpressibleBy, Validatable, Mappable {
    /// The underlying `Double` value.
    ///
    /// - Since: 1.0.0
    var value: Double { get }

    /// Creates a new instance from a `Double` value.
    ///
    /// - Parameter value: The raw value to wrap.
    /// - Since: 1.0.0
    init(_ value: Double)
}

extension DecimalRepresentable {

    // MARK: ExpressibleByFloatLiteral

    /// Creates a new instance from a floating-point literal.
    ///
    /// - Parameter value: The literal value.
    /// - Since: 1.0.0
    public init(floatLiteral value: Float) {
        self.init(.init(value))
    }

    // MARK: ExpressibleByIntegerLiteral

    /// Creates a new instance from an integer literal.
    ///
    /// - Parameter value: The literal value.
    /// - Since: 1.0.0
    public init(integerLiteral value: Int) {
        self.init(.init(value))
    }

    // MARK: Comparable

    /// Returns a Boolean value indicating whether the first value is less than the second.
    ///
    /// Comparison is performed using the underlying `value`.
    ///
    /// - Since: 1.0.0
    public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.value < rhs.value
    }

    // MARK: Zero

    /// A zero-valued instance of the conforming type.
    ///
    /// - Since: 1.0.0
    public static var zero: Self {
        .init(.zero)
    }
}
