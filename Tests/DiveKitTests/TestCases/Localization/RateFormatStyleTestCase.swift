import Testing
@testable import DiveKit

@Suite("Rate Format Style", .tags(.localization))
struct RateFormatStyleTestCase {
    @Test
    func formatStyle() {
        let sut = Rate<Pressure>(15)

        let result = sut.formatted(.rate(.perMinute(.psi), style: .full))

        #expect(result == "15 pounds per square inch per minute")
    }
}
