import XCTest

func XCTUnwrap<T>(
    _ expression: @autoclosure () throws -> T?,
    file: StaticString = #filePath,
    line: UInt = #line,
    handler: (T) -> Void) throws {
        handler(try XCTUnwrap(expression(), file: file, line: line))
    }
