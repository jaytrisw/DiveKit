@_spi(Experimental) import DiveKit
import Testing

package func expectThrowsError<T>(
    when expression: @autoclosure () throws -> T,
    then expectedError: @autoclosure () -> Error,
    _ errorHandler: ((_ error: Error) -> Void)? = .none) throws {
        do {
            _ = try expression()
            Issue.record("Expected an error to be thrown.")
        } catch let error as Error {
            #expect(error == expectedError())
            errorHandler?(error)
        } catch {
            Issue.record("Unexpected error type: \(error)")
        }
    }
