import XCTest
@testable import DiveKit

final class AtmospheresAbsolute: XCTestCase {
    
    var diveKit = DiveKit.default
    lazy var physicsCalculator = DKPhysics(with: diveKit)
    
    func test() throws {
        XCTAssertEqual(try physicsCalculator.atmospheresAbsolute(at: 0).value, 1)
        XCTAssertEqual(try physicsCalculator.atmospheresAbsolute(at: 33).value, 2)
        XCTAssertEqual(try physicsCalculator.atmospheresAbsolute(at: 66).value, 3)
        XCTAssertEqual(try physicsCalculator.atmospheresAbsolute(at: 99).value, 4)
        XCTAssertEqual(try physicsCalculator.atmospheresAbsolute(at: 132).value, 5)
        XCTAssertEqual(try physicsCalculator.atmospheresAbsolute(at: 87).round(to: 2), 3.64)
        // Test Sea Water and Metric
        diveKit = DiveKit.init(waterType: .saltWater, measurementUnit: .metric)
        physicsCalculator = DKPhysics.init(with: diveKit)
        XCTAssertEqual(try physicsCalculator.atmospheresAbsolute(at: 0).value, 1)
        XCTAssertEqual(try physicsCalculator.atmospheresAbsolute(at: 10).value, 2)
        XCTAssertEqual(try physicsCalculator.atmospheresAbsolute(at: 20).value, 3)
        XCTAssertEqual(try physicsCalculator.atmospheresAbsolute(at: 30).value, 4)
        XCTAssertEqual(try physicsCalculator.atmospheresAbsolute(at: 40).value, 5)
        XCTAssertEqual(try physicsCalculator.atmospheresAbsolute(at: 38.5).round(to: 2), 4.85)
        physicsCalculator = DKPhysics.init(waterType: .freshWater, measurementUnit: .imperial)
        XCTAssertEqual(try physicsCalculator.atmospheresAbsolute(at: 34).value, 2)
        XCTAssertEqual(try physicsCalculator.atmospheresAbsolute(at: 68).value, 3)
        physicsCalculator = DKPhysics.init(waterType: .freshWater, measurementUnit: .metric)
        XCTAssertEqual(try physicsCalculator.atmospheresAbsolute(at: 10.3).value, 2)
    }
    func testErrors() throws {
        XCTAssertThrowsError(try physicsCalculator.atmospheresAbsolute(at: -10))
    }
}
