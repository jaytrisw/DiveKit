import Foundation
@_spi(Experimental) import DiveKitCore
import DiveKitInternal

public extension Blend where State == Blended {
    /// Creates a trimix blend with nitrogen filling the fraction left by oxygen and helium.
    ///
    /// - Parameters:
    ///   - oxygen: The oxygen fraction in `0...1`.
    ///   - helium: The helium fraction in `0...1`.
    /// - Returns: A validated oxygen, helium, and nitrogen blend.
    /// - Throws: `Error.negative` if either fraction is negative, or
    ///   `Error.range` if either fraction or their sum is greater than `1`.
    ///
    /// ```swift
    /// let trimix = try Blend.trimix(oxygen: 0.18, helium: 0.45) // Tx 18/45
    /// ```
    ///
    /// - Since: 1.0.0
    @_spi(Experimental)
    static func trimix(
        oxygen: Double,
        helium: Double) throws(Error) -> Blend<Blended> {
            let callSite: CallSite = .init(object: .init(describing: Self.self), function: #function)
            let oxygenFraction = try FractionalPressure(of: .oxygen, fractionalPressure: oxygen)
            let heliumFraction = try FractionalPressure(of: .helium, fractionalPressure: helium)
            let combinedFraction = try (oxygen + helium).validate(using: .lessThanOrEqual(to: .one)) {
                .range(.upperBound($0, .one), callSite)
            }

            return .init(
                oxygenFraction,
                heliumFraction,
                try FractionalPressure(of: .nitrogen, fractionalPressure: 1 - combinedFraction))
        }
}
