import Foundation
import DiveKitCore
import DiveKitInternal

@_spi(Experimental)
public extension Buhlmann {
    /// The fraction of Bühlmann's tolerated supersaturation a diver allows.
    ///
    /// A gradient factor of `1` uses the raw Bühlmann limit. Smaller values keep
    /// compartments further below it, which gives deeper, more conservative
    /// ceilings.
    ///
    /// - Warning: See ``Buhlmann`` before relying on this model.
    ///
    /// - Since: 1.0.0
    struct GradientFactor: Sendable, Hashable {
        /// The gradient factor, greater than `0` and at most `1`.
        ///
        /// - Since: 1.0.0
        public let value: Double

        /// Creates a gradient factor.
        ///
        /// - Parameter value: The gradient factor, greater than `0` and at most `1`.
        /// - Throws: `Error.range` if `value` is not greater than `0` or is
        ///   greater than `1`.
        ///
        /// ```swift
        /// let gradientFactor = try Buhlmann.GradientFactor(0.85)
        /// ```
        ///
        /// - Since: 1.0.0
        public init(_ value: Double) throws(Error) {
            let callSite: CallSite = .from(Self.self)
            self.value = try value
                .validate(using: .greater(than: 0)) { .range(.lowerBound($0, 0), callSite) }
                .validate(using: .lessThanOrEqual(to: .one)) { .range(.upperBound($0, .one), callSite) }
        }

        private init(unchecked value: Double) {
            self.value = value
        }

        /// The raw Bühlmann limit, a gradient factor of `1`.
        ///
        /// - Since: 1.0.0
        public static var full: Self {
            .init(unchecked: .one)
        }
    }
}
