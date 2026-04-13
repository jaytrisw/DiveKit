import Foundation

/// A marker protocol for blend state types.
///
/// Blend states model whether a gas mixture is still being assembled or has
/// been validated as a complete blend.
///
/// - Since: 1.0.0
@_marker
public protocol BlendState: Sendable {}

/// A gas mixture keyed by gas type.
///
/// `Blend` stores fractional pressures for gases. The `State` generic
/// distinguishes unvalidated mixtures from validated blended mixtures.
///
/// ## Example
///
/// ```swift
/// let oxygenFraction = blend.fractionalPressure(of: Oxygen())
/// ```
///
/// - Since: 1.0.0
public struct Blend<State: BlendState>: Sendable {
    /// Storage keyed by type-erased gas identity.
    ///
    /// - Since: 1.0.0
    private var storage: [AnyGas: Double] = [:]

    /// Creates a blend from existing storage.
    ///
    /// - Parameter initialStorage: The type-erased gas storage.
    /// - Since: 1.0.0
    package init(_ initialStorage: [AnyGas: Double]) {
        self.storage = initialStorage
    }

    /// Creates a blend by copying storage from another state.
    ///
    /// - Parameter blend: The blend whose storage should be copied.
    /// - Since: 1.0.0
    package init<OtherState: BlendState>(_ blend: Blend<OtherState>) {
        self.init(blend.storage)
    }

    /// Creates a blend from gas and fractional-pressure pairs.
    ///
    /// - Parameter values: Gas and fractional-pressure pairs.
    /// - Since: 1.0.0
    package init<each Gas: GasRepresentable>(_ values: repeat ((each Gas), Double)) {
        var storage: [AnyGas: Double] = [:]
        repeat _ = storage.updateValue((each values).1, forKey: .init((each values).0))
        self.init(storage)
    }

    /// The sum of all stored fractional pressures.
    ///
    /// - Since: 1.0.0
    public var totalPressure: Double {
        storage.reduce(.zero, { $0 + $1.1 })
    }

    /// Returns the fractional pressure for a gas.
    ///
    /// - Parameter gas: The gas to look up.
    /// - Returns: The stored fractional pressure, or `0` when the gas is absent.
    /// - Since: 1.0.0
    public func fractionalPressure(of gas: some GasRepresentable) -> Double {
        .init(storage[.init(gas)] ?? .zero)
    }

    /// Returns the gases currently present in the blend.
    ///
    /// - Returns: The stored gas components.
    /// - Since: 1.0.0
    public func components() -> [any GasRepresentable] {
        storage.keys.compactMap(\.gas)
    }

    /// Sets the fractional pressure for a gas.
    ///
    /// - Parameters:
    ///   - pressure: The fractional pressure to store.
    ///   - gas: The gas to update.
    /// - Since: 1.0.0
    package mutating func setFractionalPressure<Gas: GasRepresentable>(_ pressure: Double, for gas: Gas) {
        set(.init(gas, fractionalPressure: pressure))
    }

    /// Sets a fractional pressure in storage.
    ///
    /// - Parameter fractionalPressure: The fractional pressure to store.
    /// - Since: 1.0.0
    package mutating func set<Gas: GasRepresentable>(_ fractionalPressure: FractionalPressure<Gas>) {
        storage.updateValue(fractionalPressure.value, forKey: .init(fractionalPressure.gas))
    }
}

/// Allows blends to be compared by stored gas fractions.
///
/// - Since: 1.0.0
extension Blend: Equatable {}
/// Allows validated blends to be stored in `Calculation`.
///
/// - Since: 1.0.0
extension Blend: ResultRepresentable where State == Blended {}
