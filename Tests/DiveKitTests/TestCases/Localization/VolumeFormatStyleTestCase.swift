import Testing
@testable import DiveKit

@Suite("Volume Format Style", .tags(.localization))
struct VolumeFormatStyleTestCase {
    @Test
    func formatStyle() {
        let sut = Volume(15)

        let result = sut.formatted(.volume(.cubicFeet, style: .full))

        #expect(result == "15 cubic feet")
    }
}
