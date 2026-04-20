import Testing
@testable import DiveKit

@Suite("Mass Format Style", .tags(.localization))
struct MassFormatStyleTestCase {
    @Test
    func formatStyle() {
        let sut = Mass(15)

        let result = sut.formatted(.mass(.pounds, style: .full))

        #expect(result == "15 pounds")
    }
}
