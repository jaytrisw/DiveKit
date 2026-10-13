import DiveKit
import Testing

public func expectThrowsError<T>(
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

public func expectThrowsError<S, T>(
    given: () throws(Error) -> S,
    when: (S) throws -> T,
    then errorHandler: ((_ error: Error) -> Void)? = .none) throws {
        let given: S = try given()

        do {
            _ = try when(given)
            Issue.record("Expected an error to be thrown.")
        } catch let error as Error {
            errorHandler?(error)
        }
    }
