import XCTest
@testable import DiveKit

final class AirVolumeChange: XCTestCase {
    
    var diveKit = DiveKit.default
    lazy var physicsCalculator = DKPhysics(with: diveKit)
    
    func test() throws {
        physicsCalculator = DKPhysics.init(waterType: .saltWater, measurementUnit: .metric)
        XCTAssertEqual(try physicsCalculator.airVolumeFromSurface(to: 20, volume: 6).round(to: 1), 2.0)
        XCTAssertEqual(try physicsCalculator.airVolumeToSurface(from: 20, volume: 6).round(to: 1), 18.0)
    }
    func testErrors() throws {
        XCTAssertThrowsError(try physicsCalculator.airVolumeFromSurface(to: 10, volume: -10))
        XCTAssertThrowsError(try physicsCalculator.airVolumeFromSurface(to: -10, volume: 10))
        
        XCTAssertThrowsError(try physicsCalculator.airVolumeToSurface(from: -10, volume: 10))
        XCTAssertThrowsError(try physicsCalculator.airVolumeToSurface(from: 10, volume: -10))
    }
}
