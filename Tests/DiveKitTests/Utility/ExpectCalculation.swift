import DiveKit
import Foundation
import Testing

package func expectCalculation<Result: ResultRepresentable>(
    _ calculation: @autoclosure () throws -> Calculation<Result>,
    handler: (_ result: Result, _ configuration: Configuration) throws -> Void) throws {
        let calculation = try calculation()
        try handler(calculation.result, calculation.configuration)
    }

package func given<S, Result>(
    _ given: () async throws -> S,
    when: (_ sut: S) async throws -> Result,
    then: (_ sut: S, _ result: Result) async throws -> Void) async rethrows {
        try await confirmation { confirmation in
            let sut = try await given()
            let result = try await when(sut)
            try await then(sut, result)
            confirmation()
        }
    }

package func given<S>(
    _ given: () async throws -> S,
    when: (_ sut: S) async throws -> Void) async rethrows {
        try await confirmation { confirmation in
            let sut = try await given()
            try await when(sut)
            confirmation()
        }
    }
