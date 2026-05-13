import XCTest
@testable import DiveKit

final class RateLocalizationTestCase: XCTestCase {
    func testLocalizedTitle() {
        Localization.standard.withResolver(.diveKitTestCatalog) {
            let sut = Rate<Pressure>.Unit.perMinute(.psi)

            XCTAssertEqual(sut.localizedTitle, "Pressure Rate")
        }
    }

    func testDescriptionShort() {
        Localization.standard.withResolver(.diveKitTestCatalog) {
            let sut = Rate<Pressure>.Unit.perMinute(.psi)

            XCTAssertEqual(sut.localizedDescription(for: .short), "psi/min")
        }
    }

    func testDescriptionFull() {
        Localization.standard.withResolver(.diveKitTestCatalog) {
            let sut = Rate<Volume>.Unit.perMinute(.cubicFeet)

            XCTAssertEqual(sut.localizedDescription(for: .full), "cubic feet per minute")
        }
    }

    func testQuantityFull() {
        Localization.standard.withResolver(.diveKitTestCatalog) {
            let sut = Rate<Pressure>.Unit.perMinute(.psi)

            XCTAssertEqual(sut.localization(for: .quantity(1, .full)), "1 pound per square inch per minute")
        }
    }
}
