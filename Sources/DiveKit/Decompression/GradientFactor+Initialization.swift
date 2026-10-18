import Foundation
@_spi(Experimental) import DiveKitCore
import DiveKitInternal

@_spi(Experimental)
public extension GradientFactor {
    /// Creates a gradient factor.
    ///
    /// - Parameter value: The gradient factor, at least `0.01` and at most `1`.
    /// - Throws: `Error.range` if `value` is not finite, is less than `0.01`,
    ///   or is greater than `1`.
    ///
    /// ```swift
    /// let gradientFactor = try GradientFactor(0.85)
    /// ```
    ///
    /// - Warning: See ``Buhlmann`` before relying on this model.
    ///
    /// - Since: 1.0.0
    init(_ value: Double) throws(Error) {
        let callSite: CallSite = .from(Self.self)
        self.init(unchecked: try value
            .validatedFinite(callSite)
            .validate(using: .greaterThanOrEqual(to: Buhlmann.minimumFactor)) { .range(.lowerBound($0, Buhlmann.minimumFactor), callSite) }
            .validate(using: .lessThanOrEqual(to: .one)) { .range(.upperBound($0, .one), callSite) })
    }
}
