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
    _ given: () throws -> S,
    when: (_ sut: S) throws -> Result,
    then: (_ sut: S, _ result: Result) throws -> Void) async rethrows {
        try await confirmation { confirmation in
            let sut = try given()
            let result = try when(sut)
            try then(sut, result)
            confirmation()
        }
    }
