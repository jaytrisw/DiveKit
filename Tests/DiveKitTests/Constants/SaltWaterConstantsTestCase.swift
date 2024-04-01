import TestUtility
@testable import DiveKit

final class SaltWaterConstantsTestCase: SystemUnderTestCase<Water> {
    func testImperialWeightConstants() {
        // Given
        let units = Units.imperial

        // When
        let result = sut.weight(units)

        // Then
        XCTAssertEqual(result.value, 64)
        XCTAssertEqual(result.unit, .pounds)
        XCTAssertEqual(result.volume, .cubicFeet)
    }

    func testImperialPressureIncreaseConstants() {
        // Given
        let units = Units.imperial

        // When
        let result = sut.pressure(units)

        // Then
        XCTAssertEqual(result.increase.value, 33)
        XCTAssertEqual(result.increase.unit, .feet)
    }

    func testMetricWeightConstants() {
        // Given
        let units = Units.metric

        // When
        let result = sut.weight(units)

        // Then
        XCTAssertEqual(result.value, 1.03)
        XCTAssertEqual(result.unit, .kilograms)
        XCTAssertEqual(result.volume, .liters)
    }

    func testMetricPressureIncreaseConstants() {
        // Given
        let units = Units.metric

        // When
        let result = sut.pressure(units)

        // Then
        XCTAssertEqual(result.increase.value, 10)
        XCTAssertEqual(result.increase.unit, .meters)
    }

    override func createSUT() {
        sut = .salt
    }
}
