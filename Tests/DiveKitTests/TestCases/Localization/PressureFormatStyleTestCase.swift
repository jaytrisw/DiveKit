import Testing
@testable import DiveKit

@Suite("Pressure Format Style", .tags(.localization))
struct PressureFormatStyleTestCase {
    @Test
    func formatStyle() {
        let sut = Pressure(15)

        let result = sut.formatted(.pressure(.atmospheres, style: .full))

        #expect(result == "15 atmospheres")
    }
}
