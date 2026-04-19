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
        #expect(result.value == 62.4)
        #expect(result.unit == .pounds)
        #expect(result.volume == .cubicFeet)
    }

    @Test
    func testImperialPressureIncreaseConstants() {
        // Given
        let units = Units.imperial

        // When
        let result = sut.pressure(units)

        // Then
        #expect(result.increase.value == 34)
        #expect(result.increase.unit == .feet)
    }

    @Test
    func testMetricWeightConstants() {
        // Given
        let units = Units.metric

        // When
        let result = sut.weight(units)

        // Then
        #expect(result.value == 1)
        #expect(result.unit == .kilograms)
        #expect(result.volume == .liters)
    }

    @Test
    func testMetricPressureIncreaseConstants() {
        // Given
        let units = Units.metric

        // When
        let result = sut.pressure(units)

        // Then
        #expect(result.increase.value == 10.3)
        #expect(result.increase.unit == .meters)
    }

    override func createSUT() {
        sut = .fresh
    }
}
