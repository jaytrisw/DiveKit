import Foundation

/// How narcotic a gas is.
///
/// Relative potencies follow the lipid solubility of each gas (the
/// Meyer–Overton correlation), as tabulated by Bennett and Rostain (2003):
/// P. B. Bennett and J. C. Rostain, "Inert Gas Narcosis", in *Bennett and
/// Elliott's Physiology and Medicine of Diving*, 5th ed., Saunders, 2003, p. 305.
/// That table rates oxygen at 1.7 and helium at 0.045 relative to nitrogen.
///
/// - Since: 1.0.0
public enum NarcoticPotency: Sendable {
    /// The gas is not narcotic.
    ///
    /// - Since: 1.0.0
    case none

    /// The gas is narcotic with a potency relative to nitrogen, which is `1`.
    ///
    /// The potency must be finite and non-negative. Calculations that use an
    /// invalid potency throw `Error.range`.
    ///
    /// - Since: 1.0.0
    case relative(_ potency: Double)
}

public extension NarcoticPotency {
    /// The potency of nitrogen, the reference gas.
    ///
    /// - Since: 1.0.0
    static var nitrogen: Self {
        .relative(1)
    }
}

package extension NarcoticPotency {
    /// The potency relative to nitrogen, where not narcotic is `0`.
    ///
    /// - Since: 1.0.0
    var value: Double {
        switch self {
            case .none: .zero
            case let .relative(potency): potency
        }
    }
}

/// Compares potencies by value, so `.relative(0)` equals `.none`.
///
/// - Since: 1.0.0
extension NarcoticPotency: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.value == rhs.value
    }
}

/// Hashes potencies by value, consistent with equality.
///
/// - Since: 1.0.0
extension NarcoticPotency: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(value)
    }
}
