import Testing
@testable import DiveKit

final class FreshWaterConstantsTestCase: SystemUnderTestCase<Water> {
    @Test
    func testImperialWeightConstants() {
        // Given
        let units = Units.imperial

        // When
        let result = sut.weight(units)

        // Then
        expectEqual(result.value, 62.4)
        expectEqual(result.unit, .pounds)
        expectEqual(result.volume, .cubicFeet)
    }

    @Test
    func testImperialPressureIncreaseConstants() {
        // Given
        let units = Units.imperial

        // When
        let result = sut.pressure(units)

        // Then
        expectEqual(result.increase.value, 34)
        expectEqual(result.increase.unit, .feet)
    }

    @Test
    func testMetricWeightConstants() {
        // Given
        let units = Units.metric

        // When
        let result = sut.weight(units)

        // Then
        expectEqual(result.value, 1)
        expectEqual(result.unit, .kilograms)
        expectEqual(result.volume, .liters)
    }

    @Test
    func testMetricPressureIncreaseConstants() {
        // Given
        let units = Units.metric

        // When
        let result = sut.pressure(units)

        // Then
        expectEqual(result.increase.value, 10.3)
        expectEqual(result.increase.unit, .meters)
    }

    override func createSUT() {
        sut = .fresh
    }
}
