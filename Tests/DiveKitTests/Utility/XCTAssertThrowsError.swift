import DiveKit
import XCTest

public func XCTAssertThrowsError<T>(
    when expression: @autoclosure () throws -> T,
    then expectedError: @autoclosure () -> Error,
    file: StaticString = #filePath,
    line: UInt = #line,
    _ errorHandler: ((_ error: Error) -> Void)? = .none) throws {
        XCTAssertThrowsError(try expression(), file: file, line: line) { thrownError in
            try? XCTUnwrap(thrownError as? Error) {
                XCTAssertEqual($0, expectedError(), file: file, line: line)
                errorHandler?($0)
            }
        }
    }
