import Testing
@testable import DiveKit

final class RateTestCase: SystemUnderTestCase<Rate<Pressure>> {
    @Test
    func testInit() {
        // Given
        let expected: Double = 15

        // When
        sut = .init(expected)

        // Then
        #expect(sut.value == expected)
    }

    @Test
    func testEquatable() {
        // Given
        let lhs: Rate<Pressure> = 15
        let rhs: Rate<Pressure> = 15

        // Then
        #expect(lhs == rhs)
    }

    @Test
    func testLocalization() {
        // Given
        sut = 15

        // When
        let result = sut.localization(for: .perMinute(.psi), style: .short)

        // Then
        #expect(result == "15 psi/min")
    }
}
