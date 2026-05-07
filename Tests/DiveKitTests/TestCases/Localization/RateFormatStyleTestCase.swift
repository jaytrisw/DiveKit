import XCTest
@testable import DiveKit

final class RateFormatStyleTestCase: SystemUnderTestCase<Rate<Pressure>> {
    func testFormatStyle() {
        // Given
        sut = 15

        // When
        let result = sut.formatted(.rate(.perMinute(.psi), style: .full))

        // Then
        XCTAssertEqual(result, "15 pounds per square inch per minute")
    }

    func testGermanShortFormatStyleUsesExplicitPrecision() {
        // Given
        let sut = Rate<Depth>(33)

        // When
        let result = sut.formatted(
            .rate(.perMinute(.feet), style: .short)
                .precision(.fractionLength(1))
                .locale(Locale(identifier: "de_DE")))

        // Then
        XCTAssertEqual(result, "33,0 ft/min")
    }

    func testGermanMetricShortFormatStylePreservesMeaningfulDecimalDigit() {
        // Given
        let sut = Rate<Depth>(10.3)

        // When
        let result = sut.formatted(
            .rate(.perMinute(.meters), style: .short)
                .precision(.fractionLength(1))
                .locale(Locale(identifier: "de_DE")))

        // Then
        XCTAssertEqual(result, "10,3 m/min")
    }

    func testEnglishShortFormatStyleUsesExplicitPrecision() {
        // Given
        let sut = Rate<Depth>(33)

        // When
        let result = sut.formatted(
            .rate(.perMinute(.feet), style: .short)
                .precision(.fractionLength(1))
                .locale(Locale(identifier: "en_US")))

        // Then
        XCTAssertEqual(result, "33.0 ft/min")
    }

    func testFullFormatStylePreservesBaseUnitSingularAndPluralUnits() {
        XCTAssertEqual(
            Rate<Pressure>(1).formatted(.rate(.perMinute(.psi), style: .full).locale(Locale(identifier: "en_US"))),
            "1 pound per square inch per minute")
        XCTAssertEqual(
            Rate<Pressure>(2).formatted(.rate(.perMinute(.psi), style: .full).locale(Locale(identifier: "en_US"))),
            "2 pounds per square inch per minute")
    }
}
