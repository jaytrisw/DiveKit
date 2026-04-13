import Foundation
import DiveKitCore
import DiveKitInternal

public extension FractionalPressure {
    /// Creates a fractional pressure for a given gas, validating its range.
    ///
    /// This initializer ensures the provided fractional pressure is within the
    /// valid range of `0...1` before constructing the value.
    ///
    /// - Parameters:
    ///   - gas: The gas associated with the fractional pressure.
    ///   - fractionalPressure: The fractional pressure value.
    /// - Throws: `DiveKit.Error.negative` if `fractionalPressure` is negative,
    ///   or `DiveKit.Error.range` if it is greater than `1`.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let fraction = try FractionalPressure(
    ///     of: Oxygen(),
    ///     fractionalPressure: 0.32
    /// )
    /// ```
    ///
    /// - Important: Fractional pressure must be within the closed range `0...1`.
    /// - Since: 1.0.0
    init(of gas: Gas, fractionalPressure: Double) throws(Error) {
        let callSite: CallSite = .init(object: .init(describing: Self.self), function: #function)
        try fractionalPressure.validate(using: .greaterThanOrEqual(to: .zero)) {
            .negative(.fractionalPressure($0), callSite)
        }
        try fractionalPressure.validate(using: .lessThanOrEqual(to: .one)) {
            .range(.upperBound($0, .one), callSite)
        }

        self.init(gas, fractionalPressure: fractionalPressure)
    }
}
