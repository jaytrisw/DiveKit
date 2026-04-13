import Foundation

/// A gas that can be used as a component in a blend.
///
/// Gas values are compared by type-erased identity through `AnyGas`, allowing
/// heterogeneous gas components to be stored in a single blend.
///
/// - Since: 1.0.0
public protocol GasRepresentable: Hashable, Sendable {}

public extension GasRepresentable {
    /// Returns whether this gas represents the same gas as another value.
    ///
    /// - Parameter other: The other gas to compare.
    /// - Returns: `true` when both gases have the same type-erased identity.
    /// - Since: 1.0.0
    func isEqual<Gas: GasRepresentable>(to other: Gas) -> Bool {
        AnyGas(self) == .init(other)
    }
}
