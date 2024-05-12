import XCTest
@testable import DiveKit

final class PressureLocalizationTestCase: SystemUnderTestCase<Pressure.Unit> {
    func testLocalizedTitleDImperial() {
        // Given
        sut = .psi

        // When
        let result = sut.localizedTitle

        // Then
        XCTAssertEqual(result, "Pressure")
    }

    func testLocalizedTitleMetric() {
        // Given
        sut = .bar

        // When
        let result = sut.localizedTitle

        // Then
        XCTAssertEqual(result, "Pressure")
    }

    func testLocalizedTitleAtmospheres() {
        // Given
        sut = .atmospheres

        // When
        let result = sut.localizedTitle

        // Then
        XCTAssertEqual(result, "Pressure")
    }

    func testDescriptionShortImperial() {
        // Given
        let style: LocalizationStyle = .short
        sut = .psi

        // When
        let result = sut.localizedDescription(for: style)

        // Then
        XCTAssertEqual(result, "psi")
    }

    func testDescriptionShortMetric() {
        // Given
        let style: LocalizationStyle = .short
        sut = .bar

        // When
        let result = sut.localizedDescription(for: style)

        // Then
        XCTAssertEqual(result, "bar")
    }

    func testDescriptionShortAtmospheres() {
        // Given
        let style: LocalizationStyle = .short
        sut = .atmospheres

        // When
        let result = sut.localizedDescription(for: style)

        // Then
        XCTAssertEqual(result, "atm")
    }

    func testDescriptionFullImperial() {
        // Given
        let style: LocalizationStyle = .full
        sut = .psi

        // When
        let result = sut.localizedDescription(for: style)

        // Then
        XCTAssertEqual(result, "pounds per square inch")
    }

    func testDescriptionFullMetric() {
        // Given
        let style: LocalizationStyle = .full
        sut = .bar

        // When
        let result = sut.localizedDescription(for: style)

        // Then
        XCTAssertEqual(result, "bar")
    }

    func testDescriptionFullAtmospheres() {
        // Given
        let style: LocalizationStyle = .full
        sut = .atmospheres

        // When
        let result = sut.localizedDescription(for: style)

        // Then
        XCTAssertEqual(result, "atmospheres")
    }

    func testQuantityShortImperial() {
        // Given
        let quantity: Double = .zero
        let style: LocalizationStyle = .short
        sut = .psi

        // When
        let result = sut.localization(for: .quantity(quantity, style))

        // Then
        XCTAssertEqual(result, "0 psi")
    }

    func testQuantityShortMetric() {
        // Given
        let quantity: Double = .zero
        let style: LocalizationStyle = .short
        sut = .bar

        // When
        let result = sut.localization(for: .quantity(quantity, style))

        // Then
        XCTAssertEqual(result, "0 bar")
    }

    func testQuantityShortAtmospheres() {
        // Given
        let quantity: Double = .zero
        let style: LocalizationStyle = .short
        sut = .atmospheres

        // When
        let result = sut.localization(for: .quantity(quantity, style))

        // Then
        XCTAssertEqual(result, "0 atm")
    }

    func testQuantityFullImperial() {
        // Given
        let quantity: Double = .zero
        let style: LocalizationStyle = .full
        sut = .psi

        // When
        let result = sut.localization(for: .quantity(quantity, style))

        // Then
        XCTAssertEqual(result, "0 pounds per square inch")
    }

    func testQuantityFullMetric() {
        // Given
        let quantity: Double = .zero
        let style: LocalizationStyle = .full
        sut = .bar

        // When
        let result = sut.localization(for: .quantity(quantity, style))

        // Then
        XCTAssertEqual(result, "0 bar")
    }

    func testQuantityFullAtmospheres() {
        // Given
        let quantity: Double = .zero
        let style: LocalizationStyle = .full
        sut = .atmospheres

        // When
        let result = sut.localization(for: .quantity(quantity, style))

        // Then
        XCTAssertEqual(result, "0 atmospheres")
    }

    func testOneQuantityFullImperial() {
        // Given
        let quantity: Double = 1
        let style: LocalizationStyle = .full
        sut = .psi

        // When
        let result = sut.localization(for: .quantity(quantity, style))

        // Then
        XCTAssertEqual(result, "1 pound per square inch")
    }

    func testOneQuantityFullMetric() {
        // Given
        let quantity: Double = 1
        let style: LocalizationStyle = .full
        sut = .bar

        // When
        let result = sut.localization(for: .quantity(quantity, style))

        // Then
        XCTAssertEqual(result, "1 bar")
    }

    func testOneQuantityFullAtmospheres() {
        // Given
        let quantity: Double = 1
        let style: LocalizationStyle = .full
        sut = .atmospheres

        // When
        let result = sut.localization(for: .quantity(quantity, style))

        // Then
        XCTAssertEqual(result, "1 atmosphere")
    }
}
