import XCTest
@testable import DiveKit

final class BuoyancyCalculatorMetricSaltwaterTestCase: SystemUnderTestCase<BuoyancyCalculator> {

    func testBuoyancyValidInput() {
        // Given
        let weight: Mass = 209.0
        let volume: Volume = 200.0
        let object: Object = .init(weight: weight, volume: volume)

        // When
        XCTAssertCalculation(try sut.buoyancy(of: object)) { result, configuration in
            // Then
            XCTAssertEqual(result, .negative(3))
            XCTAssertEqual(configuration, sut.configuration)
        }
    }

    func testBuoyancyInvalidWeightInput() {
        // Given
        let weight: Mass = -209.0
        let volume: Volume = 200.0
        let object: Object = .init(weight: weight, volume: volume)

        // When
        XCTAssertThrowsError(try sut.buoyancy(of: object), as: Error<Object>.self) { error in
            // Then
            XCTAssertEqual(error.value, object)
            XCTAssertEqual(error.message.key, "dive.kit.buoyancy.calculator.invalid.object")
            XCTAssertEqual(error.callSite, "BuoyancyCalculator.buoyancy(of:)")
        }
    }

    func testBuoyancyInvalidVolumeInput() {
        // Given
        let weight: Mass = 209.0
        let volume: Volume = -200.0
        let object: Object = .init(weight: weight, volume: volume)

        // When
        XCTAssertThrowsError(try sut.buoyancy(of: object), as: Error<Object>.self) { error in
            // Then
            XCTAssertEqual(error.value, object)
            XCTAssertEqual(error.message.key, "dive.kit.buoyancy.calculator.invalid.object")
            XCTAssertEqual(error.callSite, "BuoyancyCalculator.buoyancy(of:)")
        }
    }

    override func createSUT() {
        sut = .init(.metric, water: .salt)
    }
}
