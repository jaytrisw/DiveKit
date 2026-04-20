import Testing
@testable import DiveKit

@Suite("Depth Format Style", .tags(.localization))
struct DepthFormatStyleTestCase {
    @Test
    func formatStyle() {
        let sut = Depth(15)

        let result = sut.formatted(.depth(.feet, style: .full))

        #expect(result == "15 feet")
    }
}
