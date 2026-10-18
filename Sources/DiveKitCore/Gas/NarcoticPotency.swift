import Foundation

/// How narcotic a gas is.
///
/// Relative potencies follow the lipid solubility of each gas (the
/// Meyer–Overton correlation), as tabulated by Bennett and Rostain (2003):
/// P. B. Bennett and J. C. Rostain, "Inert Gas Narcosis", in *Bennett and
/// Elliott's Physiology and Medicine of Diving*, 5th ed., Saunders, 2003,
/// pp. 300–322. DiveKit takes the values from that table as reproduced by
/// J. E. Clark, "Moving in extreme environments: inert gas narcosis and
/// underwater activities", *Extreme Physiology & Medicine* 4:1, 2015, Table 2,
/// which rates oxygen at 1.7 and helium at 0.2 relative to nitrogen. Other
/// published estimates for helium range from 0.23 down to 0.045.
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
    /// Returns whether two potencies have the same value relative to nitrogen.
    ///
    /// - Parameters:
    ///   - lhs: The first potency.
    ///   - rhs: The second potency.
    /// - Returns: `true` when the values match, so `.relative(0)` equals `.none`.
    /// - Since: 1.0.0
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.value == rhs.value
    }
}

/// Hashes potencies by value, consistent with equality.
///
/// - Since: 1.0.0
extension NarcoticPotency: Hashable {
    /// Hashes the potency's value relative to nitrogen.
    ///
    /// - Parameter hasher: The hasher to update.
    /// - Since: 1.0.0
    public func hash(into hasher: inout Hasher) {
        hasher.combine(value)
    }
}
