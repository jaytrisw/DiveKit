import Foundation

/// A marker protocol for values that can be stored in a `Calculation`.
///
/// Result values are `Sendable` so calculations can be passed safely across
/// concurrency boundaries.
///
/// - Since: 1.0.0
public protocol ResultRepresentable: Sendable {}
