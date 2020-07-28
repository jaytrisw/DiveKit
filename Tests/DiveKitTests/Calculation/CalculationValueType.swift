import XCTest
@testable import DiveKit

final class CalculationValueType: XCTestCase {
    
    let calculation = Calculation(value: 10.159, for: .depthAirConsumption, diveKit: DiveKit.default)
    
    func test() throws {
        let calculationMetric = Calculation(value: 10, for: .depthAirConsumption, diveKit: DiveKit.init(waterType: .saltWater, measurementUnit: .metric))
        let calculationFreshWaterMetric = Calculation(value: 10, for: .surfaceAirConsumption, diveKit: DiveKit.init(waterType: .freshWater, measurementUnit: .metric))
        XCTAssertEqual(calculation.round(to: 2), 10.16)
        XCTAssertNotEqual(calculation, calculationFreshWaterMetric)
        XCTAssertNotEqual(calculation, calculationMetric)
        XCTAssertNotEqual(calculationMetric, calculationFreshWaterMetric)
        XCTAssertGreaterThan(calculation, calculationMetric)
    }
    
    func testCodable() throws {
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        
        let data = try encoder.encode(calculation)
        let decodedCalculation = try decoder.decode(Calculation.self, from: data)
        
        XCTAssertEqual(calculation, decodedCalculation)
    }
    
    func testHashable() throws {
        let calculation = Calculation(value: 10.159, for: .depthAirConsumption, diveKit: DiveKit.default)
        XCTAssertEqual(calculation.hashValue, self.calculation.hashValue)
    }
}
