import XCTest
@testable import DiveKit

final class PhysicsTests: XCTestCase {
    
    var physicsCalculator = DKPhysics.init()
    var diveKit = DiveKit.init()
    
    func testErrors() throws {
        XCTAssertThrowsError(try physicsCalculator.airVolumeFromSurface(volume: -10, depth: 10, decimalPlaces: 10))
        XCTAssertThrowsError(try physicsCalculator.airVolumeFromSurface(volume: 10, depth: -10, decimalPlaces: 10))
        XCTAssertThrowsError(try physicsCalculator.airVolumeFromSurface(volume: 10, depth: 10, decimalPlaces: -10))
        
        XCTAssertThrowsError(try physicsCalculator.airVolumeToSurface(volume: -10, depth: 10, decimalPlaces: 10))
        XCTAssertThrowsError(try physicsCalculator.airVolumeToSurface(volume: 10, depth: -10, decimalPlaces: 10))
        XCTAssertThrowsError(try physicsCalculator.airVolumeToSurface(volume: 10, depth: 10, decimalPlaces: -10))
        
        XCTAssertThrowsError(try physicsCalculator.atmospheresAbsolute(depth: -10, decimalPlaces: 10))
        XCTAssertThrowsError(try physicsCalculator.atmospheresAbsolute(depth: 10, decimalPlaces: -10))
        
        XCTAssertThrowsError(try physicsCalculator.gaugePressure(depth: -10, decimalPlaces: 10))
        XCTAssertThrowsError(try physicsCalculator.gaugePressure(depth: 10, decimalPlaces: -10))
        
        XCTAssertThrowsError(try physicsCalculator.pressureChange(from: -10, to: 10, decimalPlaces: 10))
        XCTAssertThrowsError(try physicsCalculator.pressureChange(from: 10, to: -10, decimalPlaces: 10))
        XCTAssertThrowsError(try physicsCalculator.pressureChange(from: 10, to: 10, decimalPlaces: -10))
    }

    func testPhysicsCalculations() throws {
        physicsCalculator = DKPhysics.init(waterType: .saltWater, measurementUnit: .metric)
        XCTAssertEqual(try physicsCalculator.airVolumeFromSurface(volume: 6, depth: 20), 2)
        XCTAssertEqual(try physicsCalculator.airVolumeToSurface(volume: 6, depth: 20), 18)
        
        diveKit = DiveKit.init(waterType: .saltWater, measurementUnit: .imperial)
        physicsCalculator = DKPhysics.init(with: diveKit)
        
        XCTAssertEqual(try physicsCalculator.pressureChange(from: 0, to: 1).roundTo(decimalPlaces: 2), 0.03)
        // Test Sea Water and Imperial
        XCTAssertEqual(try physicsCalculator.atmospheresAbsolute(depth: 0), 1)
        XCTAssertEqual(try physicsCalculator.atmospheresAbsolute(depth: 33), 2)
        XCTAssertEqual(try physicsCalculator.atmospheresAbsolute(depth: 66), 3)
        XCTAssertEqual(try physicsCalculator.atmospheresAbsolute(depth: 99), 4)
        XCTAssertEqual(try physicsCalculator.atmospheresAbsolute(depth: 132), 5)
        XCTAssertEqual(try physicsCalculator.atmospheresAbsolute(depth: 87), 3.64)
        // Test Sea Water and Metric
        diveKit = DiveKit.init(waterType: .saltWater, measurementUnit: .metric)
        physicsCalculator = DKPhysics.init(with: diveKit)
        XCTAssertEqual(try physicsCalculator.atmospheresAbsolute(depth: 0), 1)
        XCTAssertEqual(try physicsCalculator.atmospheresAbsolute(depth: 10), 2)
        XCTAssertEqual(try physicsCalculator.atmospheresAbsolute(depth: 20), 3)
        XCTAssertEqual(try physicsCalculator.atmospheresAbsolute(depth: 30), 4)
        XCTAssertEqual(try physicsCalculator.atmospheresAbsolute(depth: 40), 5)
        XCTAssertEqual(try physicsCalculator.atmospheresAbsolute(depth: 38.5), 4.85)
        physicsCalculator = DKPhysics.init(waterType: .freshWater, measurementUnit: .imperial)
        XCTAssertEqual(try physicsCalculator.atmospheresAbsolute(depth: 34), 2)
        XCTAssertEqual(try physicsCalculator.atmospheresAbsolute(depth: 68), 3)
        physicsCalculator = DKPhysics.init(waterType: .freshWater, measurementUnit: .metric)
        XCTAssertEqual(try physicsCalculator.atmospheresAbsolute(depth: 10.3), 2)
    }
    
    func testPhysicsInititalizers() {
        physicsCalculator = DKPhysics.init()
        XCTAssertEqual(physicsCalculator.diveKit.measurementUnit, DiveKit.MeasurementUnit.imperial)
        XCTAssertEqual(physicsCalculator.diveKit.waterType, DiveKit.WaterType.saltWater)
        physicsCalculator = DKPhysics.init(with: diveKit)
        XCTAssertEqual(physicsCalculator.diveKit.measurementUnit, DiveKit.MeasurementUnit.imperial)
        XCTAssertEqual(physicsCalculator.diveKit.waterType, DiveKit.WaterType.saltWater)
        physicsCalculator = DKPhysics.init(measurementUnit: .metric)
        XCTAssertEqual(physicsCalculator.diveKit.measurementUnit, DiveKit.MeasurementUnit.metric)
        XCTAssertEqual(physicsCalculator.diveKit.waterType, DiveKit.WaterType.saltWater)
        physicsCalculator = DKPhysics.init(waterType: .freshWater)
        XCTAssertEqual(physicsCalculator.diveKit.measurementUnit, DiveKit.MeasurementUnit.imperial)
        XCTAssertEqual(physicsCalculator.diveKit.waterType, DiveKit.WaterType.freshWater)
        physicsCalculator = DKPhysics.init(waterType: .freshWater, measurementUnit: .metric)
        XCTAssertEqual(physicsCalculator.diveKit.measurementUnit, DiveKit.MeasurementUnit.metric)
        XCTAssertEqual(physicsCalculator.diveKit.waterType, DiveKit.WaterType.freshWater)
    }
}
