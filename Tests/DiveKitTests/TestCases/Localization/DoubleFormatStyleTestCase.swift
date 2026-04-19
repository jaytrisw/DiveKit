import Testing
@testable import DiveKit

final class DoubleFormatStyleTestCase: SystemUnderTestCase<Double> {
    @Test
    func testFormatStyleDepth() {
        // Given
        sut = 15

        // When
        let result = sut.formatted(.depth(.feet, style: .full))

        // Then
        #expect(result == "15 feet")
    }

    @Test
    func testFormatStyleMass() {
        // Given
        sut = 15

        // When
        let result = sut.formatted(.mass(.pounds, style: .full))

        // Then
        #expect(result == "15 pounds")
    }

    @Test
    func testFormatStylePressure() {
        // Given
        sut = 15

        // When
        let result = sut.formatted(.pressure(.atmospheres, style: .full))

        // Then
        #expect(result == "15 atmospheres")
    }

    @Test
    func testFormatStyleVolume() {
        // Given
        sut = 15

        // When
        let result = sut.formatted(.volume(.cubicFeet, style: .full))

        // Then
        #expect(result == "15 cubic feet")
    }
}
