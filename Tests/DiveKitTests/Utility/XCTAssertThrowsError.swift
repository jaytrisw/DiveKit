import XCTest

public func XCTAssertThrowsError<T, E: Error>(
    _ expression: @autoclosure () throws -> T,
    _ message: @autoclosure () -> String = "",
    as error: E.Type = E.self,
    file: StaticString = #filePath,
    line: UInt = #line,
    _ errorHandler: (_ error: E) -> Void = { _ in }) {
        XCTAssertThrowsError(try expression(), message(), file: file, line: line) { error in
            guard let error = error as? E else {
                XCTFail(message(), file: file, line: line)
                return
            }
            errorHandler(error)
        }
    }
