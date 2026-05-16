import Testing
@testable import DiveKit

@Suite(.tags(.localization))
struct DoubleFormatStyleTests {
    @Test func formatStyleDepth() {
        withTestLocalization(.test) {
            // Given
            let sut: Double = 15

            // When
            let result = sut.formatted(.depth(.feet, style: .full))

            // Then
            #expect(result == "15 feet")
        }
    }

    @Test func formatStyleMass() {
        withTestLocalization(.test) {
            // Given
            let sut: Double = 15

            // When
            let result = sut.formatted(.mass(.pounds, style: .full))

            // Then
            #expect(result == "15 pounds")
        }
    }

    @Test func formatStylePressure() {
        withTestLocalization(.test) {
            // Given
            let sut: Double = 15

            // When
            let result = sut.formatted(.pressure(.atmospheres, style: .full))

            // Then
            #expect(result == "15 atmospheres")
        }
    }

    @Test func formatStyleVolume() {
        withTestLocalization(.test) {
            // Given
            let sut: Double = 15

            // When
            let result = sut.formatted(.volume(.cubicFeet, style: .full))

            // Then
            #expect(result == "15 cubic feet")
        }
    }
}
