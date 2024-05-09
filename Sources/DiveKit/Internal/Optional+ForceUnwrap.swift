import Foundation

internal extension Optional {
    func forceUnwrap(
        _ message: @autoclosure () -> String,
        file: StaticString = #file,
        line: UInt = #line) -> Wrapped {
            guard case let .some(wrapped) = self else {
                fatalError(message(), file: file, line: line)
            }
            return wrapped
        }
}
