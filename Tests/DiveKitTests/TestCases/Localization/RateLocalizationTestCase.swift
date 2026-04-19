import Testing
@testable import DiveKit

final class RateLocalizationTestCase {
    @Test
    func testLocalizedTitle() {
        let sut = Rate<Pressure>.Unit.perMinute(.psi)

        expectEqual(sut.localizedTitle, "Pressure Rate")
    }

    @Test
    func testDescriptionShort() {
        let sut = Rate<Pressure>.Unit.perMinute(.psi)

        expectEqual(sut.localizedDescription(for: .short), "psi/min")
    }

    @Test
    func testDescriptionFull() {
        let sut = Rate<Volume>.Unit.perMinute(.cubicFeet)

        expectEqual(sut.localizedDescription(for: .full), "cubic feet per minute")
    }

    @Test
    func testQuantityFull() {
        let sut = Rate<Pressure>.Unit.perMinute(.psi)

        expectEqual(sut.localization(for: .quantity(1, .full)), "1 pound per square inch per minute")
    }
}
