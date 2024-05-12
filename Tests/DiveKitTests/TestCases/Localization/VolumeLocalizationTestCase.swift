import XCTest
@testable import DiveKit

final class VolumeLocalizationTestCase: SystemUnderTestCase<Volume.Unit> {
    func testLocalizedTitleDImperial() {
        // Given
        sut = .cubicFeet

        // When
        let result = sut.localizedTitle

        // Then
        XCTAssertEqual(result, "Volume")
    }

    func testLocalizedTitleMetric() {
        // Given
        sut = .liters

        // When
        let result = sut.localizedTitle

        // Then
        XCTAssertEqual(result, "Volume")
    }

    func testDescriptionShortImperial() {
        // Given
        let style: LocalizationStyle = .short
        sut = .cubicFeet

        // When
        let result = sut.localizedDescription(for: style)

        // Then
        XCTAssertEqual(result, "cu ft")
    }

    func testDescriptionShortMetric() {
        // Given
        let style: LocalizationStyle = .short
        sut = .liters

        // When
        let result = sut.localizedDescription(for: style)

        // Then
        XCTAssertEqual(result, "l")
    }

    func testDescriptionFullImperial() {
        // Given
        let style: LocalizationStyle = .full
        sut = .cubicFeet

        // When
        let result = sut.localizedDescription(for: style)

        // Then
        XCTAssertEqual(result, "cubic feet")
    }

    func testDescriptionFullMetric() {
        // Given
        let style: LocalizationStyle = .full
        sut = .liters

        // When
        let result = sut.localizedDescription(for: style)

        // Then
        XCTAssertEqual(result, "liters")
    }

    func testQuantityShortImperial() {
        // Given
        let quantity: Double = .zero
        let style: LocalizationStyle = .short
        sut = .cubicFeet

        // When
        let result = sut.localization(for: .quantity(quantity, style))

        // Then
        XCTAssertEqual(result, "0 cu ft")
    }

    func testQuantityShortMetric() {
        // Given
        let quantity: Double = .zero
        let style: LocalizationStyle = .short
        sut = .liters

        // When
        let result = sut.localization(for: .quantity(quantity, style))

        // Then
        XCTAssertEqual(result, "0 l")
    }

    func testQuantityFullImperial() {
        // Given
        let quantity: Double = .zero
        let style: LocalizationStyle = .full
        sut = .cubicFeet

        // When
        let result = sut.localization(for: .quantity(quantity, style))

        // Then
        XCTAssertEqual(result, "0 cubic feet")
    }

    func testQuantityFullMetric() {
        // Given
        let quantity: Double = .zero
        let style: LocalizationStyle = .full
        sut = .liters

        // When
        let result = sut.localization(for: .quantity(quantity, style))

        // Then
        XCTAssertEqual(result, "0 liters")
    }

    func testOneQuantityFullImperial() {
        // Given
        let quantity: Double = 1
        let style: LocalizationStyle = .full
        sut = .cubicFeet

        // When
        let result = sut.localization(for: .quantity(quantity, style))

        // Then
        XCTAssertEqual(result, "1 cubic foot")
    }

    func testOneQuantityFullMetric() {
        // Given
        let quantity: Double = 1
        let style: LocalizationStyle = .full
        sut = .liters

        // When
        let result = sut.localization(for: .quantity(quantity, style))

        // Then
        XCTAssertEqual(result, "1 liter")
    }
}
