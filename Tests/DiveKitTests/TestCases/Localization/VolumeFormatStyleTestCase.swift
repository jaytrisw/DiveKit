import XCTest
@testable import DiveKit

final class VolumeFormatStyleTestCase: SystemUnderTestCase<Volume> {
    func testFormatStyle() {
        // Given
        sut = 15

        // When
        let result = sut.formatted(.volume(.cubicFeet, style: .full))

        // Then
        XCTAssertEqual(result, "15 cubic feet")
    }
}
