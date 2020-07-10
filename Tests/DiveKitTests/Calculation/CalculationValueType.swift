import XCTest
@testable import DiveKit

final class CalculationValueType: XCTestCase {
    func test() throws {
        guard let calculationFromString = Calculation("1000") else { fatalError() }
        let calculation = Calculation.depthAirConsumption(value: 10.159, diveKit: DiveKit.default)
        let calculationMetric = Calculation.respiratoryMinuteVolume(value: 10, diveKit: DiveKit.init(waterType: .saltWater, measurementUnit: .metric))
        let calculationFreshWaterMetric = Calculation.surfaceAirConsumption(value: 10, diveKit: DiveKit.init(waterType: .freshWater, measurementUnit: .metric))
        let calculationFloatLiteral = Calculation(floatLiteral: 160.0)
        XCTAssertEqual(calculation.round(to: 2), 10.16)
        XCTAssertEqual(calculationFromString, 1000)
        XCTAssertEqual(calculation.description, "10.159")
        XCTAssertNotEqual(calculation.hashValue, calculationFromString.hashValue)
        XCTAssertNil(Calculation("This is a string"))
        XCTAssertLessThan(calculation, calculationFromString)
        XCTAssertNotEqual(calculation, calculationFreshWaterMetric)
        XCTAssertNotEqual(calculation, calculationMetric)
        XCTAssertNotEqual(calculationMetric, calculationFreshWaterMetric)
        XCTAssertGreaterThan(calculationFloatLiteral, calculation)
    }
}
