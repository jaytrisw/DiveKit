import Foundation

/// The state marker for a gas blend that is still being assembled.
///
/// A `Blend<Unblended>` may be incomplete or invalid until it is validated and
/// converted into `Blend<Blended>`.
///
/// - Since: 1.0.0
public enum Unblended: BlendState, Sendable {}
