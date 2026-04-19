import Testing
@testable import DiveKit

final class VolumeFormatStyleTestCase: SystemUnderTestCase<Volume> {
    @Test
    func testFormatStyle() {
        // Given
        sut = 15

        // When
        let result = sut.formatted(.volume(.cubicFeet, style: .full))

        // Then
        #expect(result == "15 cubic feet")
    }
}
