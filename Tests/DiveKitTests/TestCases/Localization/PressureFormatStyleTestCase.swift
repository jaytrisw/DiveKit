import XCTest
@testable import DiveKit

final class PressureFormatStyleTestCase: SystemUnderTestCase<Pressure> {
    func testFormatStyle() {
        // Given
        sut = 15

        // When
        let result = sut.formatted(.pressure(.atmospheres, style: .full))

        // Then
        XCTAssertEqual(result, "15 atmospheres")
    }

    func testGermanShortFormatStyleUsesExplicitPrecision() {
        // Given
        sut = 33

        // When
        let result = sut.formatted(
            .pressure(.atmospheres, style: .short)
                .precision(.fractionLength(1))
                .locale(Locale(identifier: "de_DE")))

        // Then
        XCTAssertEqual(result, "33,0 atm")
    }

    func testGermanMetricShortFormatStylePreservesMeaningfulDecimalDigit() {
        // Given
        sut = 10.3

        // When
        let result = sut.formatted(
            .pressure(.bar, style: .short)
                .precision(.fractionLength(1))
                .locale(Locale(identifier: "de_DE")))

        // Then
        XCTAssertEqual(result, "10,3 bar")
    }

    func testEnglishShortFormatStyleUsesExplicitPrecision() {
        // Given
        sut = 33

        // When
        let result = sut.formatted(
            .pressure(.atmospheres, style: .short)
                .precision(.fractionLength(1))
                .locale(Locale(identifier: "en_US")))

        // Then
        XCTAssertEqual(result, "33.0 atm")
    }

    func testFullFormatStylePreservesSingularAndPluralUnits() {
        XCTAssertEqual(
            Pressure(1).formatted(.pressure(.psi, style: .full).locale(Locale(identifier: "en_US"))),
            "1 pound per square inch")
        XCTAssertEqual(
            Pressure(2).formatted(.pressure(.psi, style: .full).locale(Locale(identifier: "en_US"))),
            "2 pounds per square inch")
        XCTAssertEqual(
            Pressure(1).formatted(.pressure(.atmospheres, style: .full).locale(Locale(identifier: "en_US"))),
            "1 atmosphere")
        XCTAssertEqual(
            Pressure(2).formatted(.pressure(.atmospheres, style: .full).locale(Locale(identifier: "en_US"))),
            "2 atmospheres")
    }
}
