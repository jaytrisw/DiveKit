import Testing
@testable import DiveKit

final class RateFormatStyleTestCase: SystemUnderTestCase<Rate<Pressure>> {
    @Test
    func testFormatStyle() {
        // Given
        sut = 15

        // When
        let result = sut.formatted(.rate(.perMinute(.psi), style: .full))

        // Then
        expectEqual(result, "15 pounds per square inch per minute")
    }
}
