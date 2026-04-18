import Foundation

/// The state marker for a validated gas blend.
///
/// A `Blend<Blended>` represents a gas mixture that should satisfy blend
/// invariants, such as a total fractional pressure of `1`.
///
/// - Since: 1.0.0
public enum Blended: BlendState, Sendable {}
