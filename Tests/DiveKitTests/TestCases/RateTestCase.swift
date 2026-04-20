import Testing
@testable import DiveKit

@Suite("Rate", .tags(.rate))
struct RateTestCase {
    @Test
    func initialization() {
        let expected: Double = 15

        let sut = Rate<Pressure>(expected)

        #expect(sut.value == expected)
    }

    @Test
    func equatable() {
        let lhs: Rate<Pressure> = 15
        let rhs: Rate<Pressure> = 15

        #expect(lhs == rhs)
    }

    @Test
    func localization() {
        let sut = Rate<Pressure>(15)

        let result = sut.localization(for: .perMinute(.psi), style: .short)

        #expect(result == "15 psi/min")
    }
}
