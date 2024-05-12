import XCTest
@testable import DiveKit

final class MassLocalizationTestCase: SystemUnderTestCase<Mass.Unit> {
    func testLocalizedTitleDImperial() {
        // Given
        sut = .pounds

        // When
        let result = sut.localizedTitle

        // Then
        XCTAssertEqual(result, "Mass")
    }

    func testLocalizedTitleMetric() {
        // Given
        sut = .kilograms

        // When
        let result = sut.localizedTitle

        // Then
        XCTAssertEqual(result, "Mass")
    }

    func testDescriptionShortImperial() {
        // Given
        let style: LocalizationStyle = .short
        sut = .pounds

        // When
        let result = sut.localizedDescription(for: style)

        // Then
        XCTAssertEqual(result, "lbs")
    }

    func testDescriptionShortMetric() {
        // Given
        let style: LocalizationStyle = .short
        sut = .kilograms

        // When
        let result = sut.localizedDescription(for: style)

        // Then
        XCTAssertEqual(result, "km")
    }

    func testDescriptionFullImperial() {
        // Given
        let style: LocalizationStyle = .full
        sut = .pounds

        // When
        let result = sut.localizedDescription(for: style)

        // Then
        XCTAssertEqual(result, "pounds")
    }

    func testDescriptionFullMetric() {
        // Given
        let style: LocalizationStyle = .full
        sut = .kilograms

        // When
        let result = sut.localizedDescription(for: style)

        // Then
        XCTAssertEqual(result, "kilograms")
    }

    func testQuantityShortImperial() {
        // Given
        let quantity: Double = .zero
        let style: LocalizationStyle = .short
        sut = .pounds

        // When
        let result = sut.localization(for: .quantity(quantity, style))

        // Then
        XCTAssertEqual(result, "0 lbs")
    }

    func testQuantityShortMetric() {
        // Given
        let quantity: Double = .zero
        let style: LocalizationStyle = .short
        sut = .kilograms

        // When
        let result = sut.localization(for: .quantity(quantity, style))

        // Then
        XCTAssertEqual(result, "0 km")
    }

    func testQuantityFullImperial() {
        // Given
        let quantity: Double = .zero
        let style: LocalizationStyle = .full
        sut = .pounds

        // When
        let result = sut.localization(for: .quantity(quantity, style))

        // Then
        XCTAssertEqual(result, "0 pounds")
    }

    func testQuantityFullMetric() {
        // Given
        let quantity: Double = .zero
        let style: LocalizationStyle = .full
        sut = .kilograms

        // When
        let result = sut.localization(for: .quantity(quantity, style))

        // Then
        XCTAssertEqual(result, "0 kilograms")
    }

    func testOneQuantityFullImperial() {
        // Given
        let quantity: Double = 1
        let style: LocalizationStyle = .full
        sut = .pounds

        // When
        let result = sut.localization(for: .quantity(quantity, style))

        // Then
        XCTAssertEqual(result, "1 pound")
    }

    func testOneQuantityFullMetric() {
        // Given
        let quantity: Double = 1
        let style: LocalizationStyle = .full
        sut = .kilograms

        // When
        let result = sut.localization(for: .quantity(quantity, style))

        // Then
        XCTAssertEqual(result, "1 kilogram")
    }
}
