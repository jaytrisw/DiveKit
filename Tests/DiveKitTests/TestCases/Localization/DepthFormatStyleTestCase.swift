import XCTest
@testable import DiveKit

final class DepthFormatStyleTestCase: SystemUnderTestCase<Depth> {
    func testFormatStyle() {
        // Given
        sut = 15

        // When
        let result = sut.formatted(.depth(.feet, style: .full))

        // Then
        XCTAssertEqual(result, "15 feet")
    }
}
