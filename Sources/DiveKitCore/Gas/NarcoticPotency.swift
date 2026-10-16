import Foundation

/// How narcotic a gas is.
///
/// Relative potencies follow the lipid solubility of each gas (the
/// Meyer–Overton correlation), as tabulated by Bennett (2004).
///
/// - Since: 1.0.0
public enum NarcoticPotency: Sendable {
    /// The gas is not narcotic.
    ///
    /// - Since: 1.0.0
    case none

    /// The gas is narcotic with a potency relative to nitrogen, which is `1`.
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
