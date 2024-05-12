import XCTest
@testable import DiveKit

final class DoubleFormatStyleTestCase: SystemUnderTestCase<Double> {
    func testFormatStyleDepth() {
        // Given
        sut = 15

        // When
        let result = sut.formatted(.depth(.feet, style: .full))

        // Then
        XCTAssertEqual(result, "15 feet")
    }

    func testFormatStyleMass() {
        // Given
        sut = 15

        // When
        let result = sut.formatted(.mass(.pounds, style: .full))

        // Then
        XCTAssertEqual(result, "15 pounds")
    }

    func testFormatStylePressure() {
        // Given
        sut = 15

        // When
        let result = sut.formatted(.pressure(.atmospheres, style: .full))

        // Then
        XCTAssertEqual(result, "15 atmospheres")
    }

    func testFormatStyleVolume() {
        // Given
        sut = 15

        // When
        let result = sut.formatted(.volume(.cubicFeet, style: .full))

        // Then
        XCTAssertEqual(result, "15 cubic feet")
    }
}
