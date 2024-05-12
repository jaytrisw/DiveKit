import XCTest
@testable import DiveKit

final class DepthLocalizationTestCase: SystemUnderTestCase<Depth.Unit> {
    func testLocalizedTitleDImperial() {
        // Given
        sut = .feet

        // When
        let result = sut.localizedTitle

        // Then
        XCTAssertEqual(result, "Depth")
    }

    func testLocalizedTitleMetric() {
        // Given
        sut = .meters

        // When
        let result = sut.localizedTitle

        // Then
        XCTAssertEqual(result, "Depth")
    }

    func testDescriptionShortImperial() {
        // Given
        let style: LocalizationStyle = .short
        sut = .feet

        // When
        let result = sut.localizedDescription(for: style)

        // Then
        XCTAssertEqual(result, "ft")
    }

    func testDescriptionShortMetric() {
        // Given
        let style: LocalizationStyle = .short
        sut = .meters

        // When
        let result = sut.localizedDescription(for: style)

        // Then
        XCTAssertEqual(result, "m")
    }

    func testDescriptionFullImperial() {
        // Given
        let style: LocalizationStyle = .full
        sut = .feet

        // When
        let result = sut.localizedDescription(for: style)

        // Then
        XCTAssertEqual(result, "feet")
    }

    func testDescriptionFullMetric() {
        // Given
        let style: LocalizationStyle = .full
        sut = .meters

        // When
        let result = sut.localizedDescription(for: style)

        // Then
        XCTAssertEqual(result, "meters")
    }

    func testQuantityShortImperial() {
        // Given
        let quantity: Double = .zero
        let style: LocalizationStyle = .short
        sut = .feet

        // When
        let result = sut.localization(for: .quantity(quantity, style))

        // Then
        XCTAssertEqual(result, "0 ft")
    }

    func testQuantityShortMetric() {
        // Given
        let quantity: Double = .zero
        let style: LocalizationStyle = .short
        sut = .meters

        // When
        let result = sut.localization(for: .quantity(quantity, style))

        // Then
        XCTAssertEqual(result, "0 m")
    }

    func testQuantityFullImperial() {
        // Given
        let quantity: Double = .zero
        let style: LocalizationStyle = .full
        sut = .feet

        // When
        let result = sut.localization(for: .quantity(quantity, style))

        // Then
        XCTAssertEqual(result, "0 feet")
    }

    func testQuantityFullMetric() {
        // Given
        let quantity: Double = .zero
        let style: LocalizationStyle = .full
        sut = .meters

        // When
        let result = sut.localization(for: .quantity(quantity, style))

        // Then
        XCTAssertEqual(result, "0 meters")
    }

    func testOneQuantityFullImperial() {
        // Given
        let quantity: Double = 1
        let style: LocalizationStyle = .full
        sut = .feet

        // When
        let result = sut.localization(for: .quantity(quantity, style))

        // Then
        XCTAssertEqual(result, "1 foot")
    }

    func testOneQuantityFullMetric() {
        // Given
        let quantity: Double = 1
        let style: LocalizationStyle = .full
        sut = .meters

        // When
        let result = sut.localization(for: .quantity(quantity, style))

        // Then
        XCTAssertEqual(result, "1 meter")
    }
}
