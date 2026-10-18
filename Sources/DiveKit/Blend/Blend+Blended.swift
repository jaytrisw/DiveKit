import Foundation
import DiveKitCore
import DiveKitInternal

public extension Blend where State == Blended {
    /// Returns the fractional pressure of a specific gas in the blend.
    ///
    /// - Parameter gas: The gas whose fractional pressure should be retrieved.
    /// - Returns: A ``FractionalPressure`` representing the gas's contribution to the blend.
    /// - Throws: `Error.negative` if the stored fractional pressure is
    ///   negative, or `Error.range` if it is not finite or is greater than `1`.
    ///
    /// ```swift
    /// let oxygenFractionalPressure = try blend.fractionalPressure(of: .oxygen)
    /// ```
    ///
    /// - Note: The ``Blend`` must already be in a valid blended state.
    /// - Since: 1.0.0
    func fractionalPressure<Gas: GasRepresentable>(of gas: Gas) throws(Error) -> FractionalPressure<Gas> {
        try .init(of: gas, fractionalPressure: fractionalPressure(of: gas))
    }
}

extension Blend where State == Blended {
    /// The fraction of each gas in the blend, keyed by type-erased gas identity.
    var fractions: [AnyGas: Double] {
        Dictionary(components().map { (AnyGas($0), fractionalPressure(of: $0)) }) { $1 }
    }
}

extension CallSite {
    /// Creates call-site context for diagnostics that originate from a blend.
    ///
    /// The object name is derived from the ``Blend`` type description and paired
    /// with the caller's function name. This keeps blend validation errors
    /// focused on the API that requested the operation.
    ///
    /// - Parameters:
    ///   - blend: The blend used to derive the diagnostic object name.
    ///   - function: The calling function. Defaults to the caller's function name.
    /// - Returns: A ``CallSite`` for blend-related errors and diagnostics.
    ///
    /// - Note: The object description is derived from `String(describing:)`
    ///   and truncated to remove parameter details for readability.
    /// - Since: 1.0.0
    static func from<State: BlendState>(_ blend: Blend<State>, function: StaticString = #function) -> Self {
        let object = String(describing: blend)
            .components(separatedBy: "(")
            .first ?? String(describing: blend)

        return .init(
            object: object,
            function: function)
    }
}
