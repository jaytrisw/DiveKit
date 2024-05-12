import XCTest
@testable import DiveKit

final class MassFormatStyleTestCase: SystemUnderTestCase<Mass> {
    func testFormatStyle() {
        // Given
        sut = 15

        // When
        let result = sut.formatted(.mass(.pounds, style: .full))

        // Then
        XCTAssertEqual(result, "15 pounds")
    }
}
