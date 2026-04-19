import Testing

func expectUnwrapped<T>(
    _ expression: @autoclosure () throws -> T?,
    handler: (T) throws -> Void) throws {
        try handler(try #require(try expression()))
    }
