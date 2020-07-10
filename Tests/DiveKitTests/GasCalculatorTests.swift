import XCTest
@testable import DiveKit

final class GasCalculatorTests: XCTestCase {
    
    // MARK: - Instance Properties
    var diveKit = DiveKit.default
    //var physics = DKPhysics.init()
    var gasCalculator = DKGasCalculator.init()
    
    // MARK: - Calculation Methods
    func testPartialPressure() {
        diveKit = DiveKit.default
        let gas = Gas.air
        gasCalculator = DKGasCalculator.init(with: diveKit)
        let airPartialPressure = gas.partialPressure
        XCTAssertEqual(try gasCalculator.partialPressure(of: .air).fractionOxygen, airPartialPressure.fractionOxygen)
        XCTAssertEqual(try gasCalculator.partialPressure(of: .air).fractionNitrogen, airPartialPressure.fractionNitrogen)
        XCTAssertEqual(try gasCalculator.partialPressure(of: .air).fractionTraceGases, airPartialPressure.fractionTraceGases)
        XCTAssertThrowsError(try gasCalculator.partialPressure(of: gas, at: -20))
    }
    func testConstants() {
        diveKit = DiveKit.default
        XCTAssertEqual(diveKit.constants.oneAtmosphere, 33)
    }
    func testDKError() {
        let error = DiveKit.Error.positiveValueRequired(parameter: .depth, value: -30)
        XCTAssertEqual(error.title, "Depth Error")
        XCTAssertEqual(error.localizedDescription, "Depth requires a positive value, -30.0 was provided.")
        XCTAssertEqual(error.recoverySuggestion, "Provide a positive value for the depth parameter, rather than -30.0")
        XCTAssertEqual(error.value, -30)

        XCTAssertEqual(error.failureReason, error.localizedDescription)
    }
    
    func testGasType() {
        XCTAssertEqual(try Gas.enrichedAir(32).percentOxygen, 32)
        XCTAssertEqual(Gas.air.percentOxygen, 20.9)
    }
    
    
    // MARK: - Initializers
    
    func testGasCalculatorInitializers() {
        gasCalculator = DKGasCalculator.init()
        XCTAssertEqual(gasCalculator.diveKit.measurementUnit, DiveKit.MeasurementUnit.imperial)
        XCTAssertEqual(gasCalculator.diveKit.waterType, DiveKit.WaterType.saltWater)
        diveKit = DiveKit.default
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
    func testGasesInitializers() {
        gasCalculator = DKGasCalculator.init(waterType: .saltWater, measurementUnit: .imperial)
        let tank = DKTank(ratedPressure: 3000, volume: 80, type: .aluminumStandard)
        XCTAssertEqual(try gasCalculator.respiratoryMinuteVolume(gasConsumed: 900, tank: tank, depth: 66, time: 10), 0.8)
        XCTAssertEqual(try gasCalculator.surfaceAirConsumption(time: 10, depth: 90, gasConsumed: 600).roundTo(decimalPlaces: 1), 16.1)
        
        XCTAssertThrowsError(try gasCalculator.depthAirConsumption(gasConsumed: -200, time: 200))
        XCTAssertThrowsError(try gasCalculator.depthAirConsumption(gasConsumed: 200, time: -200))
        
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
        ("testPartialPressure", testPartialPressure),
        ("testConstants", testConstants),
        ("testDKError", testDKError),
        ("testGasCalculatorInitializers", testGasCalculatorInitializers),
        ("testGasesInitializers", testGasesInitializers)
    ]
}
