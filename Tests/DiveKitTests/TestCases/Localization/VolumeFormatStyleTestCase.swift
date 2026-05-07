import XCTest
@testable import DiveKit

final class VolumeFormatStyleTestCase: SystemUnderTestCase<Volume> {
    func testFormatStyle() {
        // Given
        sut = 15

        // When
        let result = sut.formatted(.volume(.cubicFeet, style: .full))

        // Then
        XCTAssertEqual(result, "15 cubic feet")
    }

    func testGermanShortFormatStyleUsesExplicitPrecision() {
        // Given
        sut = 33

        // When
        let result = sut.formatted(
            .volume(.cubicFeet, style: .short)
                .precision(.fractionLength(1))
                .locale(Locale(identifier: "de_DE")))

        // Then
        XCTAssertEqual(result, "33,0 cu ft")
    }

    func testGermanMetricShortFormatStylePreservesMeaningfulDecimalDigit() {
        // Given
        sut = 10.3

        // When
        let result = sut.formatted(
            .volume(.liters, style: .short)
                .precision(.fractionLength(1))
                .locale(Locale(identifier: "de_DE")))

        // Then
        XCTAssertEqual(result, "10,3 l")
    }

    func testEnglishShortFormatStyleUsesExplicitPrecision() {
        // Given
        sut = 33

        // When
        let result = sut.formatted(
            .volume(.cubicFeet, style: .short)
                .precision(.fractionLength(1))
                .locale(Locale(identifier: "en_US")))

        // Then
        XCTAssertEqual(result, "33.0 cu ft")
    }

    func testFullFormatStylePreservesSingularAndPluralUnits() {
        XCTAssertEqual(
            Volume(1).formatted(.volume(.cubicFeet, style: .full).locale(Locale(identifier: "en_US"))),
            "1 cubic foot")
        XCTAssertEqual(
            Volume(2).formatted(.volume(.cubicFeet, style: .full).locale(Locale(identifier: "en_US"))),
            "2 cubic feet")
        XCTAssertEqual(Volume(1).formatted(.volume(.liters, style: .full).locale(Locale(identifier: "en_US"))), "1 liter")
        XCTAssertEqual(Volume(2).formatted(.volume(.liters, style: .full).locale(Locale(identifier: "en_US"))), "2 liters")
    }
}
