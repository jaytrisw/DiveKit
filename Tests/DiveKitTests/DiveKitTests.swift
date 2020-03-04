import XCTest
@testable import DiveKit

final class DiveKitTests: XCTestCase {
    
    // MARK: - Instance Properties
    var diveKit = DiveKit.init()
    var physics = DKPhysics.init()
    var gasCalculator = DKGasCalculator.init()
    
    // MARK: - Calculation Methods
    func testAtmospheresAbsolute() {
        diveKit = DiveKit.init(waterType: .saltWater, measurementUnit: .imperial)
        physics = DKPhysics.init(with: diveKit)
        
        XCTAssertEqual(try! physics.pressureChange(from: 0, to: 1).roundTo(decimalPlaces: 2), 0.03)
        // Test Sea Water and Imperial
        XCTAssertEqual(try! physics.atmospheresAbsolute(depth: 0), 1)
        XCTAssertEqual(try! physics.atmospheresAbsolute(depth: 33), 2)
        XCTAssertEqual(try! physics.atmospheresAbsolute(depth: 66), 3)
        XCTAssertEqual(try! physics.atmospheresAbsolute(depth: 99), 4)
        XCTAssertEqual(try! physics.atmospheresAbsolute(depth: 132), 5)
        XCTAssertEqual(try! physics.atmospheresAbsolute(depth: 87), 3.64)
        // Test Sea Water and Metric
        diveKit = DiveKit.init(waterType: .saltWater, measurementUnit: .metric)
        physics = DKPhysics.init(with: diveKit)
        XCTAssertEqual(try! physics.atmospheresAbsolute(depth: 0), 1)
        XCTAssertEqual(try! physics.atmospheresAbsolute(depth: 10), 2)
        XCTAssertEqual(try! physics.atmospheresAbsolute(depth: 20), 3)
        XCTAssertEqual(try! physics.atmospheresAbsolute(depth: 30), 4)
        XCTAssertEqual(try! physics.atmospheresAbsolute(depth: 40), 5)
        XCTAssertEqual(try! physics.atmospheresAbsolute(depth: 38.5), 4.85)
        physics = DKPhysics.init(waterType: .freshWater, measurementUnit: .imperial)
        XCTAssertEqual(try! physics.atmospheresAbsolute(depth: 34), 2)
        XCTAssertEqual(try! physics.atmospheresAbsolute(depth: 68), 3)
        physics = DKPhysics.init(waterType: .freshWater, measurementUnit: .metric)
        XCTAssertEqual(try! physics.atmospheresAbsolute(depth: 10.3), 2)
        XCTAssertThrowsError(try physics.pressureChange(from: -2, to: 0))
        XCTAssertThrowsError(try physics.pressureChange(from: 0, to: -2))
        
        XCTAssertThrowsError(try physics.atmospheresAbsolute(depth: -2, decimalPlaces: 0))
        XCTAssertThrowsError(try physics.atmospheresAbsolute(depth: 2, decimalPlaces: -2))
        
        XCTAssertThrowsError(try physics.gaugePressure(depth: -2, decimalPlaces: 0))
        XCTAssertThrowsError(try physics.gaugePressure(depth: 2, decimalPlaces: -2))
        
    }
    func testPartialPressure() {
        diveKit = DiveKit.init()
        let gas = Gas.air
        gasCalculator = DKGasCalculator.init(with: diveKit)
        let airPartialPressure = gas.partialPressure
        XCTAssertEqual(try gasCalculator.partialPressure(of: .air).fractionOxygen, airPartialPressure.fractionOxygen)
        XCTAssertEqual(try gasCalculator.partialPressure(of: .air).fractionNitrogen, airPartialPressure.fractionNitrogen)
        XCTAssertEqual(try gasCalculator.partialPressure(of: .air).fractionTraceGases, airPartialPressure.fractionTraceGases)
        XCTAssertThrowsError(try gasCalculator.partialPressure(of: gas, at: -20))
    }
    func testConstants() {
        XCTAssertEqual(DKConstants.imperial.pressureChange.saltWater, 0.0303)
        XCTAssertEqual(DKConstants.imperial.oneAtmosphere.saltWater, 33)
        XCTAssertEqual(DKConstants.imperial.weightOfWaterByUnit.saltWater, 64)
        XCTAssertEqual(DKConstants.imperial.pressureChange.freshWater, 0.0294)
        XCTAssertEqual(DKConstants.imperial.oneAtmosphere.freshWater, 34)
        XCTAssertEqual(DKConstants.imperial.weightOfWaterByUnit.freshWater, 62.4)
        XCTAssertEqual(DKConstants.metric.pressureChange.saltWater, 0.1)
        XCTAssertEqual(DKConstants.metric.oneAtmosphere.saltWater, 10)
        XCTAssertEqual(DKConstants.metric.weightOfWaterByUnit.saltWater, 1.03)
        XCTAssertEqual(DKConstants.metric.pressureChange.freshWater, 0.097)
        XCTAssertEqual(DKConstants.metric.oneAtmosphere.freshWater, 10.3)
        XCTAssertEqual(DKConstants.metric.weightOfWaterByUnit.freshWater, 1.0)
    }
    func testDKError() {
        let error = DKError.positiveValueRequired
        XCTAssertEqual(error.title, "Positive Value Expected")
        XCTAssertEqual(error.localizedDescription, "A positive value was expected")
        XCTAssertEqual(error.failureReason, error.localizedDescription)    }
    func testGasType() {
        XCTAssertEqual(try Gas.enrichedAir(32).percentOxygen, 32)
        XCTAssertEqual(Gas.air.percentOxygen, 20.9)
    }
    
    func testStevePrior() {
        let diveKit = DiveKit.init(waterType: .saltWater, measurementUnit: .metric)
        XCTAssertEqual(try DKPhysics(with: diveKit).airVolumeFromSurface(volume: 6, depth: 20), 2)
    }
    
    // MARK: - Inititalizers
    func testDiveKitInititalizers() {
        diveKit = DiveKit.init()
        XCTAssertEqual(diveKit.measurementUnit, DiveKit.MeasurementUnit.imperial)
        XCTAssertEqual(diveKit.waterType, DiveKit.WaterType.saltWater)
        diveKit = DiveKit.init(measurementUnit: .metric)
        XCTAssertEqual(diveKit.measurementUnit, DiveKit.MeasurementUnit.metric)
        XCTAssertEqual(diveKit.waterType, DiveKit.WaterType.saltWater)
        diveKit = DiveKit.init(waterType: .freshWater)
        XCTAssertEqual(diveKit.measurementUnit, DiveKit.MeasurementUnit.imperial)
        XCTAssertEqual(diveKit.waterType, DiveKit.WaterType.freshWater)
        diveKit = DiveKit.init(waterType: .freshWater, measurementUnit: .metric)
        XCTAssertEqual(diveKit.measurementUnit, DiveKit.MeasurementUnit.metric)
        XCTAssertEqual(diveKit.waterType, DiveKit.WaterType.freshWater)
    }
    func testPhysicsInititalizers() {
        physics = DKPhysics.init()
        XCTAssertEqual(physics.diveKit.measurementUnit, DiveKit.MeasurementUnit.imperial)
        XCTAssertEqual(physics.diveKit.waterType, DiveKit.WaterType.saltWater)
        diveKit = DiveKit.init()
        physics = DKPhysics.init(with: diveKit)
        XCTAssertEqual(physics.diveKit.measurementUnit, DiveKit.MeasurementUnit.imperial)
        XCTAssertEqual(physics.diveKit.waterType, DiveKit.WaterType.saltWater)
        physics = DKPhysics.init(measurementUnit: .metric)
        XCTAssertEqual(physics.diveKit.measurementUnit, DiveKit.MeasurementUnit.metric)
        XCTAssertEqual(physics.diveKit.waterType, DiveKit.WaterType.saltWater)
        physics = DKPhysics.init(waterType: .freshWater)
        XCTAssertEqual(physics.diveKit.measurementUnit, DiveKit.MeasurementUnit.imperial)
        XCTAssertEqual(physics.diveKit.waterType, DiveKit.WaterType.freshWater)
        physics = DKPhysics.init(waterType: .freshWater, measurementUnit: .metric)
        XCTAssertEqual(physics.diveKit.measurementUnit, DiveKit.MeasurementUnit.metric)
        XCTAssertEqual(physics.diveKit.waterType, DiveKit.WaterType.freshWater)
    }
    func testGasCalculatorInititalizers() {
        gasCalculator = DKGasCalculator.init()
        XCTAssertEqual(gasCalculator.diveKit.measurementUnit, DiveKit.MeasurementUnit.imperial)
        XCTAssertEqual(gasCalculator.diveKit.waterType, DiveKit.WaterType.saltWater)
        diveKit = DiveKit.init()
        gasCalculator = DKGasCalculator.init(with: diveKit)
        XCTAssertEqual(gasCalculator.diveKit.measurementUnit, DiveKit.MeasurementUnit.imperial)
        XCTAssertEqual(gasCalculator.diveKit.waterType, DiveKit.WaterType.saltWater)
        gasCalculator = DKGasCalculator.init(measurementUnit: .metric)
        XCTAssertEqual(gasCalculator.diveKit.measurementUnit, DiveKit.MeasurementUnit.metric)
        XCTAssertEqual(gasCalculator.diveKit.waterType, DiveKit.WaterType.saltWater)
        gasCalculator = DKGasCalculator.init(waterType: .freshWater)
        XCTAssertEqual(gasCalculator.diveKit.measurementUnit, DiveKit.MeasurementUnit.imperial)
        XCTAssertEqual(gasCalculator.diveKit.waterType, DiveKit.WaterType.freshWater)
        gasCalculator = DKGasCalculator.init(waterType: .freshWater, measurementUnit: .metric)
        XCTAssertEqual(gasCalculator.diveKit.measurementUnit, DiveKit.MeasurementUnit.metric)
        XCTAssertEqual(gasCalculator.diveKit.waterType, DiveKit.WaterType.freshWater)
    }
    func testGasesInititalizers() {
        gasCalculator = DKGasCalculator.init()
        XCTAssertEqual(gasCalculator.diveKit.measurementUnit, DiveKit.MeasurementUnit.imperial)
        XCTAssertEqual(gasCalculator.diveKit.waterType, DiveKit.WaterType.saltWater)
        diveKit = DiveKit.init()
        gasCalculator = DKGasCalculator.init(with: diveKit)
        XCTAssertEqual(gasCalculator.diveKit.measurementUnit, DiveKit.MeasurementUnit.imperial)
        XCTAssertEqual(gasCalculator.diveKit.waterType, DiveKit.WaterType.saltWater)
        gasCalculator = DKGasCalculator.init(measurementUnit: .metric)
        XCTAssertEqual(gasCalculator.diveKit.measurementUnit, DiveKit.MeasurementUnit.metric)
        XCTAssertEqual(gasCalculator.diveKit.waterType, DiveKit.WaterType.saltWater)
        gasCalculator = DKGasCalculator.init(waterType: .freshWater)
        XCTAssertEqual(gasCalculator.diveKit.measurementUnit, DiveKit.MeasurementUnit.imperial)
        XCTAssertEqual(gasCalculator.diveKit.waterType, DiveKit.WaterType.freshWater)
        gasCalculator = DKGasCalculator.init(waterType: .freshWater, measurementUnit: .metric)
        XCTAssertEqual(gasCalculator.diveKit.measurementUnit, DiveKit.MeasurementUnit.metric)
        XCTAssertEqual(gasCalculator.diveKit.waterType, DiveKit.WaterType.freshWater)
        gasCalculator = DKGasCalculator.init(waterType: .saltWater, measurementUnit: .imperial)
        let tank = DKTank(ratedPressure: 3000, volume: 80, type: .aluminumStandard)
        XCTAssertEqual(try gasCalculator.respiratoryMinuteVolume(gasConsumed: 900, tank: tank, depth: 66, time: 10), 0.8)
        XCTAssertEqual(try gasCalculator.surfaceAirConsumption(time: 10, depth: 90, gasConsumed: 600).roundTo(decimalPlaces: 1), 16.1)
        
        XCTAssertThrowsError(try gasCalculator.surfaceAirConsumption(time: -10, depth: 90, gasConsumed: 600))
        XCTAssertThrowsError(try gasCalculator.surfaceAirConsumption(time: 10, depth: -90, gasConsumed: 600))
        XCTAssertThrowsError(try gasCalculator.surfaceAirConsumption(time: 10, depth: 90, gasConsumed: -600))
        let negativeRatedPressure = DKTank(ratedPressure: -3000, volume: 80, type: .aluminumStandard)
        let negativeCapacity = DKTank(ratedPressure: 3000, volume: -80, type: .aluminumStandard)
        XCTAssertThrowsError(try gasCalculator.respiratoryMinuteVolume(gasConsumed: -900, tank: tank, depth: 66, time: 10))
        XCTAssertThrowsError(try gasCalculator.respiratoryMinuteVolume(gasConsumed: 900, tank: negativeRatedPressure, depth: 66, time: 10))
        XCTAssertThrowsError(try gasCalculator.respiratoryMinuteVolume(gasConsumed: 900, tank: negativeCapacity, depth: 66, time: 10))
        XCTAssertThrowsError(try gasCalculator.respiratoryMinuteVolume(gasConsumed: 900, tank: tank, depth: -66, time: 10))
        XCTAssertThrowsError(try gasCalculator.respiratoryMinuteVolume(gasConsumed: 900, tank: tank, depth: 66, time: -10))
    }

    static var allTests = [
        ("testAtmospheresAbsolute", testAtmospheresAbsolute),
        ("testPartialPressure", testPartialPressure),
        ("testConstants", testConstants),
        ("testDKError", testDKError),
        ("testDiveKitInititalizers", testDiveKitInititalizers),
        ("testPhysicsInititalizers", testPhysicsInititalizers),
        ("testGasCalculatorInititalizers", testGasCalculatorInititalizers),
        ("testGasesInititalizers", testGasesInititalizers)
    ]
}
