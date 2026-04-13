import Foundation
import DiveKitCore

extension Optional {
    /// Returns the wrapped value or raises an Objective-C exception when `nil`.
    ///
    /// This is an internal escape hatch for invariants that cannot be expressed
    /// as typed Swift errors. It behaves like force-unwrapping, but allows a
    /// custom diagnostic message.
    ///
    /// - Parameters:
    ///   - message: A message describing the failure. Evaluated only if the value is `nil`.
    ///   - file: Reserved for call-site context. Defaults to the caller's file.
    ///   - line: Reserved for call-site context. Defaults to the caller's line.
    ///
    /// - Returns: The wrapped value if `self` is `.some`.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let value: Int? = 42
    /// let unwrapped = value.forceUnwrap("Expected value to be present")
    /// ```
    ///
    /// - Warning: If the value is `nil`, this method raises an `NSException`.
    ///   Swift code cannot recover from Objective-C exceptions, so use this only
    ///   for programmer errors or unrecoverable internal invariants.
    /// - Note: This method does not throw `DiveKitCore.Error`; it raises an
    ///   Objective-C exception instead.
    /// - Since: 1.0.0
    package func forceUnwrap(
        _ message: @autoclosure () -> String = "",
        file: StaticString = #file,
        line: UInt = #line) -> Wrapped {
            guard case let .some(wrapped) = self else {
                return raise(.invalidArgumentException, message())
            }
            return wrapped
        }
}

/// Raises an Objective-C exception and never returns normally.
///
/// This helper exists so internal code can express unrecoverable invariant
/// failures in expression contexts. It raises `NSException` first, then calls
/// `preconditionFailure(_:)` as a Swift control-flow fallback.
///
/// - Parameters:
///   - name: The name of the exception to raise.
///   - message: A message describing the reason for the exception.
///   - userInfo: Optional additional information associated with the exception.
///
/// - Returns: This function never returns normally. The generic return type
///   allows it to be used in expression contexts.
///
/// - Warning: Calling this function will raise an Objective-C exception and
///   terminate execution. It should only be used when interoperating with APIs
///   that expect exception-based failure.
///
/// - Note: The `preconditionFailure` is included as a fallback to satisfy Swift’s
///   control flow analysis, but is not expected to be reached under normal circumstances.
/// - Since: 1.0.0
package func raise<T>(
    _ name: NSExceptionName,
    _ message: @autoclosure () -> String,
    userInfo: [String: Any]? = .none) -> T {
        NSException(name: name, reason: message(), userInfo: userInfo).raise()

        preconditionFailure(message())
    }
