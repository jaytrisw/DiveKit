import Foundation

/// The domain error type thrown by DiveKit calculations and validation APIs.
///
/// Throwing APIs in DiveKit use typed throws and throw this error type for
/// recoverable domain failures.
///
/// - Since: 1.0.0
public enum Error: Swift.Error, Sendable {
    /// A negative input was provided where only non-negative values are valid.
    ///
    /// - Since: 1.0.0
    case negative(_ negative: Negative, _ callSite: CallSite)
    /// A tank-specific input was invalid.
    ///
    /// - Since: 1.0.0
    case tank(_ tank: Tank, _ callSite: CallSite)
    /// A blend-specific input or invariant was invalid.
    ///
    /// - Since: 1.0.0
    case blend(_ blend: Blend, _ callSite: CallSite)
    /// A value violated an expected bound.
    ///
    /// - Since: 1.0.0
    case range(_ range: Range, _ callSite: CallSite)
}

/// Allows domain errors to be compared.
///
/// - Since: 1.0.0
extension Error: Equatable {}
