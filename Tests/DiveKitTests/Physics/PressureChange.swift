import XCTest
@testable import DiveKit

final class PressureChange: XCTestCase {
    
    var diveKit = DiveKit.default
    lazy var physicsCalculator = DKPhysics(with: diveKit)
    
    func test() throws {
        XCTAssertEqual(try physicsCalculator.pressureChange(from: 0, to: 1).round(to: 4), diveKit.constants.pressureChange)
    }
    func testErrors() throws {
        XCTAssertThrowsError(try physicsCalculator.pressureChange(from: -10, to: 10))
        XCTAssertThrowsError(try physicsCalculator.pressureChange(from: 10, to: -10))
    }
}
