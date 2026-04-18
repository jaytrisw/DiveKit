import Foundation

/// A type-erased gas identity used as a blend storage key.
///
/// `AnyGas` wraps concrete gases in `AnyHashable` so heterogeneous gas types can
/// be stored in the same dictionary. It is marked `@unchecked Sendable` because
/// the wrapped values are constrained to `GasRepresentable`, which is `Sendable`.
///
/// - Since: 1.0.0
package struct AnyGas: Hashable, @unchecked Sendable {
    /// The type-erased hashable gas value.
    ///
    /// - Since: 1.0.0
    package let value: AnyHashable

    /// The wrapped gas value, if it can be recovered.
    ///
    /// - Since: 1.0.0
    package var gas: (any GasRepresentable)? {
        value as? (any GasRepresentable)
    }

    /// Creates a type-erased gas identity.
    ///
    /// - Parameter gas: The gas to type erase.
    /// - Since: 1.0.0
    package init(_ gas: some GasRepresentable) {
        value = AnyHashable(gas)
    }

    /// Returns whether two type-erased gases have the same identity.
    ///
    /// - Parameters:
    ///   - lhs: The first type-erased gas.
    ///   - rhs: The second type-erased gas.
    /// - Returns: `true` when the wrapped identities are equal.
    /// - Since: 1.0.0
    package static func == (lhs: AnyGas, rhs: AnyGas) -> Bool {
        lhs.value == rhs.value
    }

    /// Hashes the type-erased gas identity.
    ///
    /// - Parameter hasher: The hasher to update.
    /// - Since: 1.0.0
    package func hash(into hasher: inout Hasher) {
        hasher.combine(value)
    }
}
