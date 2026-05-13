import XCTest
@testable import DiveKit

final class DepthFormatStyleTestCase: LocalizationSystemUnderTestCase<Depth> {
    func testFormatStyle() {
        // Given
        sut = 15

        // When
        let result = sut.formatted(.depth(.feet, style: .full))

        // Then
        XCTAssertEqual(result, "15 feet")
    }

    func testGermanShortFormatStyleUsesLocaleDecimalSeparator() {
        // Given
        sut = 33

        // When
        let result = sut.formatted(.depth(.feet, style: .short).locale(Locale(identifier: "de_DE")))

        // Then
        XCTAssertEqual(result, "33 ft")
        XCTAssertNotEqual(result, "33,000 ft")
    }

    func testGermanShortFormatStyleUsesExplicitPrecision() {
        // Given
        sut = 33

        // When
        let result = sut.formatted(
            .depth(.feet, style: .short)
                .precision(.fractionLength(1))
                .locale(Locale(identifier: "de_DE")))

        // Then
        XCTAssertEqual(result, "33,0 ft")
    }

    func testGermanMetricShortFormatStylePreservesMeaningfulDecimalDigit() {
        // Given
        sut = 10.3

        // When
        let result = sut.formatted(
            .depth(.meters, style: .short)
                .precision(.fractionLength(1))
                .locale(Locale(identifier: "de_DE")))

        // Then
        XCTAssertEqual(result, "10,3 m")
    }

    func testEnglishShortFormatStyleUsesExplicitPrecision() {
        // Given
        sut = 33

        // When
        let result = sut.formatted(
            .depth(.feet, style: .short)
                .precision(.fractionLength(1))
                .locale(Locale(identifier: "en_US")))

        // Then
        XCTAssertEqual(result, "33.0 ft")
    }

    func testFullFormatStylePreservesSingularAndPluralUnits() {
        XCTAssertEqual(Depth(1).formatted(.depth(.feet, style: .full).locale(Locale(identifier: "en_US"))), "1 foot")
        XCTAssertEqual(Depth(2).formatted(.depth(.feet, style: .full).locale(Locale(identifier: "en_US"))), "2 feet")
        XCTAssertEqual(Depth(1).formatted(.depth(.meters, style: .full).locale(Locale(identifier: "en_US"))), "1 meter")
        XCTAssertEqual(Depth(2).formatted(.depth(.meters, style: .full).locale(Locale(identifier: "en_US"))), "2 meters")
    }
}
