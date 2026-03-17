import Foundation

internal extension Optional {
    func forceUnwrap(
        _ message: @autoclosure () -> String = "",
        file: StaticString = #file,
        line: UInt = #line) -> Wrapped {
            guard case let .some(wrapped) = self else {
                return raise(.invalidArgumentException, message())
            }
            return wrapped
        }
}

internal func raise<T>(
    _ name: NSExceptionName,
    _ message: @autoclosure () -> String,
    userInfo: [String: Any]? = .none) -> T {
        NSException(name: name, reason: message(), userInfo: userInfo).raise()

        preconditionFailure(message())
    }
