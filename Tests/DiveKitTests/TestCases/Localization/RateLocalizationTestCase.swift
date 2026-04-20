import Testing
@testable import DiveKit

struct RateLocalizationTestCase {
    @Test
    func testLocalizedTitle() {
        let sut = Rate<Pressure>.Unit.perMinute(.psi)

        #expect(sut.localizedTitle == "Pressure Rate")
    }

    @Test
    func testDescriptionShort() {
        let sut = Rate<Pressure>.Unit.perMinute(.psi)

        #expect(sut.localizedDescription(for: .short) == "psi/min")
    }

    @Test
    func testDescriptionFull() {
        let sut = Rate<Volume>.Unit.perMinute(.cubicFeet)

        #expect(sut.localizedDescription(for: .full) == "cubic feet per minute")
    }

    @Test
    func testQuantityFull() {
        let sut = Rate<Pressure>.Unit.perMinute(.psi)

        #expect(sut.localization(for: .quantity(1, .full)) == "1 pound per square inch per minute")
    }
}
