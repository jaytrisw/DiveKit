import DiveKitCore
import XCTest

package func XCTAssertCalculation<Result: CalculationResultRepresentable>(
    _ calculation: @autoclosure () throws -> Calculation<Result>,
    _ message: @autoclosure () -> String = "",
    file: StaticString = #filePath,
    line: UInt = #line,
    handler: (_ result: Result, _ configuration: Configuration) -> Void) {
        guard let calculation = try? calculation() else {
            XCTFail(message(), file: file, line: line)
            return
        }
        handler(calculation.result, calculation.configuration)
    }
