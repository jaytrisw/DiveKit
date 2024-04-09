import DiveKit
import XCTest

public func XCTAssertThrowsError<T>(
    when expression: @autoclosure () throws -> T,
    _ message: @autoclosure () -> String = "",
    then expectedError: @autoclosure () -> Error,
    file: StaticString = #filePath,
    line: UInt = #line,
    _ errorHandler: (_ error: Error) -> Void = { _ in }) throws {
        XCTAssertThrowsError(try expression(), message(), file: file, line: line) { thrownError in
            guard let thrownError = thrownError as? Error else {
                XCTFail(message(), file: file, line: line)
                return
            }
            XCTAssertEqual(thrownError, expectedError(), message(), file: file, line: line)
            errorHandler(thrownError)
        }
    }
