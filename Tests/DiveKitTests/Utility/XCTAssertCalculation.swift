import DiveKit
import Foundation
import XCTest

package func XCTAssertCalculation<Result: ResultRepresentable>(
    _ calculation: @autoclosure () throws -> Calculation<Result>,
    file: StaticString = #filePath,
    line: UInt = #line,
    handler: (_ result: Result, _ configuration: Configuration) -> Void) throws {
        try XCTUnwrap(try? calculation()) {
            handler($0.result, $0.configuration)
        }
    }
