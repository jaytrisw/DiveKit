import Testing
@testable import DiveKit

final class PressureFormatStyleTestCase: SystemUnderTestCase<Pressure> {
    @Test
    func testFormatStyle() {
        // Given
        sut = 15

        // When
        let result = sut.formatted(.pressure(.atmospheres, style: .full))

        // Then
        expectEqual(result, "15 atmospheres")
    }
}
