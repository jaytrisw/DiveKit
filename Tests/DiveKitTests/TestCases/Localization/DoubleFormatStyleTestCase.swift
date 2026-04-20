import Testing
@testable import DiveKit

@Suite("Double Format Style", .tags(.localization))
struct DoubleFormatStyleTestCase {
    @Test
    func formatStyleDepth() {
        let sut = 15.0

        let result = sut.formatted(.depth(.feet, style: .full))

        #expect(result == "15 feet")
    }

    @Test
    func formatStyleMass() {
        let sut = 15.0

        let result = sut.formatted(.mass(.pounds, style: .full))

        #expect(result == "15 pounds")
    }

    @Test
    func formatStylePressure() {
        let sut = 15.0

        let result = sut.formatted(.pressure(.atmospheres, style: .full))

        #expect(result == "15 atmospheres")
    }

    @Test
    func formatStyleVolume() {
        let sut = 15.0

        let result = sut.formatted(.volume(.cubicFeet, style: .full))

        #expect(result == "15 cubic feet")
    }
}
