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
        sut = .pounds

        // When
        let result = sut.localizedDescription(for: .short)

        // Then
        XCTAssertEqual(result, "lbs")
    }

    func testDescriptionShortMetric() {
        // Given
        sut = .kilograms

        // When
        let result = sut.localizedDescription(for: .short)

        // Then
        XCTAssertEqual(result, "km")
    }

    func testDescriptionFullImperial() {
        // Given
        sut = .pounds

        // When
        let result = sut.localizedDescription(for: .full)

        // Then
        XCTAssertEqual(result, "pounds")
    }

    func testDescriptionFullMetric() {
        // Given
        sut = .kilograms

        // When
        let result = sut.localizedDescription(for: .full)

        // Then
        XCTAssertEqual(result, "kilograms")
    }

    func testQuantityShortImperial() {
        // Given
        sut = .pounds

        // When
        let result = sut.localization(for: .quantity(.zero, .short))

        // Then
        XCTAssertEqual(result, "0.000 lbs")
    }

    func testQuantityShortMetric() {
        // Given
        sut = .kilograms

        // When
        let result = sut.localization(for: .quantity(.zero, .short))

        // Then
        XCTAssertEqual(result, "0.000 km")
    }

    func testQuantityFullImperial() {
        // Given
        sut = .pounds

        // When
        let result = sut.localization(for: .quantity(.zero, .full))

        // Then
        XCTAssertEqual(result, "0.000 pounds")
    }

    func testQuantityFullMetric() {
        // Given
        sut = .kilograms

        // When
        let result = sut.localization(for: .quantity(.zero, .full))

        // Then
        XCTAssertEqual(result, "0.000 kilograms")
    }

    func testOneQuantityFullImperial() {
        // Given
        sut = .pounds

        // When
        let result = sut.localization(for: .quantity(1, .full))

        // Then
        XCTAssertEqual(result, "1.000 pound")
    }

    func testOneQuantityFullMetric() {
        // Given
        sut = .kilograms

        // When
        let result = sut.localization(for: .quantity(1, .full))

        // Then
        XCTAssertEqual(result, "1.000 kilogram")
    }
}
