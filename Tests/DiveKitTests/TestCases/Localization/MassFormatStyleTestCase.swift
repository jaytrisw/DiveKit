import XCTest
@testable import DiveKit

final class MassFormatStyleTestCase: LocalizationSystemUnderTestCase<Mass> {
    func testFormatStyle() {
        // Given
        sut = 15

        // When
        let result = sut.formatted(.mass(.pounds, style: .full))

        // Then
        XCTAssertEqual(result, "15 pounds")
    }

    func testGermanShortFormatStyleUsesExplicitPrecision() {
        // Given
        sut = 33

        // When
        let result = sut.formatted(
            .mass(.pounds, style: .short)
                .precision(.fractionLength(1))
                .locale(Locale(identifier: "de_DE")))

        // Then
        XCTAssertEqual(result, "33,0 lbs")
    }

    func testGermanMetricShortFormatStylePreservesMeaningfulDecimalDigit() {
        // Given
        sut = 10.3

        // When
        let result = sut.formatted(
            .mass(.kilograms, style: .short)
                .precision(.fractionLength(1))
                .locale(Locale(identifier: "de_DE")))

        // Then
        XCTAssertEqual(result, "10,3 kg")
    }

    func testEnglishShortFormatStyleUsesExplicitPrecision() {
        // Given
        sut = 33

        // When
        let result = sut.formatted(
            .mass(.pounds, style: .short)
                .precision(.fractionLength(1))
                .locale(Locale(identifier: "en_US")))

        // Then
        XCTAssertEqual(result, "33.0 lbs")
    }

    func testFullFormatStylePreservesSingularAndPluralUnits() {
        XCTAssertEqual(Mass(1).formatted(.mass(.pounds, style: .full).locale(Locale(identifier: "en_US"))), "1 pound")
        XCTAssertEqual(Mass(2).formatted(.mass(.pounds, style: .full).locale(Locale(identifier: "en_US"))), "2 pounds")
        XCTAssertEqual(
            Mass(1).formatted(.mass(.kilograms, style: .full).locale(Locale(identifier: "en_US"))),
            "1 kilogram")
        XCTAssertEqual(
            Mass(2).formatted(.mass(.kilograms, style: .full).locale(Locale(identifier: "en_US"))),
            "2 kilograms")
    }
}
