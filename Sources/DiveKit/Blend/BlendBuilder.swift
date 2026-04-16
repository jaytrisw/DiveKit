import Foundation
import DiveKitCore
import DiveKitInternal

package extension Blend where State == Blended {
    /// Creates a blended gas mixture using a result builder.
    ///
    /// This initializer allows declarative construction of a `Blend` in the `Blended` state
    /// using `BlendBuilder`.
    ///
    /// - Parameter builder: A result builder that produces a blended `Blend`.
    ///
    /// ```swift
    /// let blend = Blend<Blended> {
    ///     FractionalPressure(Oxygen(), fractionalPressure: 0.21)
    ///     FractionalPressure(Nitrogen(), fractionalPressure: 0.79)
    /// }
    /// ```
    ///
    /// - Note: The builder must produce a valid blended state.
    /// - Since: 1.0.0
    init(@BlendBuilder builder: () -> Self) {
        self = builder()
    }
}

package extension Blend where State == Unblended {
    /// Creates an unblended gas mixture using a result builder.
    ///
    /// This initializer allows declarative construction of a `Blend` in the `Unblended` state
    /// using `BlendBuilder`.
    ///
    /// - Parameter builder: A result builder that produces an unblended `Blend`.
    ///
    /// ```swift
    /// let blend = Blend<Unblended> {
    ///     FractionalPressure(Oxygen(), fractionalPressure: 0.32)
    ///     FractionalPressure(Nitrogen(), fractionalPressure: 0.68)
    /// }
    /// ```
    ///
    /// - Note: The resulting blend may require validation via `blend()`
    ///   before it can be used as a `Blended` state.
    /// - Since: 1.0.0
    init(@BlendBuilder builder: () -> Self) {
        self = builder()
    }
}

public extension Blend where State == Blended {
    /// Creates a blended gas mixture using a throwing result builder.
    ///
    /// This initializer allows declarative construction of a `Blend` in the `Blended` state
    /// where the builder may throw during evaluation.
    ///
    /// - Parameter builder: A throwing result builder that produces a blended `Blend`.
    /// - Throws: The `Error` thrown by `builder`.
    ///
    /// ```swift
    /// let blend = try Blend<Blended> {
    ///     try FractionalPressure(of: Oxygen(), fractionalPressure: 0.21)
    ///     try FractionalPressure(of: Nitrogen(), fractionalPressure: 0.79)
    /// }
    /// ```
    ///
    /// - Note: The builder must produce a valid blended state.
    /// - Since: 1.0.0
    init(@BlendBuilder builder: () throws(Error) -> Self) throws(Error) {
        self = try builder()
    }
}

public extension Blend where State == Unblended {
    /// Creates an unblended gas mixture using a throwing result builder.
    ///
    /// This initializer allows declarative construction of a `Blend` in the `Unblended` state
    /// where the builder may throw during evaluation.
    ///
    /// - Parameter builder: A throwing result builder that produces an unblended `Blend`.
    /// - Throws: The `Error` thrown by `builder`.
    ///
    /// ```swift
    /// let blend = try Blend<Unblended> {
    ///     try FractionalPressure(of: Oxygen(), fractionalPressure: 0.32)
    ///     try FractionalPressure(of: Nitrogen(), fractionalPressure: 0.68)
    /// }
    /// ```
    ///
    /// - Note: The resulting blend may require validation via `blend()`
    ///   before it can be converted into a `Blended` state.
    /// - Since: 1.0.0
    init(@BlendBuilder builder: () throws(Error) -> Self) throws(Error) {
        self = try builder()
    }
}
