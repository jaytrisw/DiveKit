import DiveKit
import Foundation
import Testing

package func expectCalculation<Result: ResultRepresentable>(
    _ calculation: @autoclosure () throws -> Calculation<Result>,
    handler: (_ result: Result, _ configuration: Configuration) throws -> Void) throws {
        let calculation = try calculation()
        try handler(calculation.result, calculation.configuration)
    }
