import XCTest
@testable import DiveKit

final class PressureFormatStyleTestCase: SystemUnderTestCase<Pressure> {
    func testFormatStyle() {
        // Given
        sut = 15

        // When
        let result = sut.formatted(.pressure(.atmospheres, style: .full))

        // Then
        XCTAssertEqual(result, "15 atmospheres")
    }
}
