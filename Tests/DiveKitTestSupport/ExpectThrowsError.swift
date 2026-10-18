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

/// Expects `expression` to reject a NaN input as
/// `.range(.upperBound(NaN, .greatestFiniteMagnitude))` at `callSite`.
///
/// NaN never equals itself, so ``expectThrowsError(when:then:_:)`` cannot
/// compare the payload; this checks each part instead, plus `localizationValue`.
package func expectThrowsNaNUpperBound<T>(
    when expression: @autoclosure () throws -> T,
    callSite expectedCallSite: CallSite,
    sourceLocation: SourceLocation = #_sourceLocation) {
        let error = #expect(throws: Error.self, sourceLocation: sourceLocation) {
            _ = try expression()
        }
        guard case let .range(.upperBound(provided, upperBound), callSite) = error else {
            Issue.record("Expected an upper-bound error, got \(String(describing: error)).", sourceLocation: sourceLocation)
            return
        }
        #expect(provided.isNaN, sourceLocation: sourceLocation)
        #expect(upperBound == .greatestFiniteMagnitude, sourceLocation: sourceLocation)
        #expect(callSite == expectedCallSite, sourceLocation: sourceLocation)
        #expect(error?.localizationValue == "dive.kit.error.range.upper.bound", sourceLocation: sourceLocation)
    }
