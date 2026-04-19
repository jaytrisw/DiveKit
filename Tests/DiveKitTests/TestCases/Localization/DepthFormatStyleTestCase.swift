import Testing
@testable import DiveKit

final class DepthFormatStyleTestCase: SystemUnderTestCase<Depth> {
    @Test
    func testFormatStyle() {
        // Given
        sut = 15

        // When
        let result = sut.formatted(.depth(.feet, style: .full))

        // Then
        #expect(result == "15 feet")
    }
}
