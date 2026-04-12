import Foundation
import DiveKitCore

extension Optional {
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

package func raise<T>(
    _ name: NSExceptionName,
    _ message: @autoclosure () -> String,
    userInfo: [String: Any]? = .none) -> T {
        NSException(name: name, reason: message(), userInfo: userInfo).raise()

        preconditionFailure(message())
    }
