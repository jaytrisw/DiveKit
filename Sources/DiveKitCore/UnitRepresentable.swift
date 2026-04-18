import Foundation

/// A marker protocol for units that can be attached to calculation results.
///
/// Unit types conform to `Equatable` and `Sendable` so results can be compared
/// and safely passed across concurrency domains.
///
/// - Since: 1.0.0
public protocol UnitRepresentable: Equatable, Sendable {}
