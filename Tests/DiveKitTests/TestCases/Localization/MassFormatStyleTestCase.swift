import Testing
@testable import DiveKit

final class MassFormatStyleTestCase: SystemUnderTestCase<Mass> {
    @Test
    func testFormatStyle() {
        // Given
        sut = 15

        // When
        let result = sut.formatted(.mass(.pounds, style: .full))

        // Then
        #expect(result == "15 pounds")
    }
}
