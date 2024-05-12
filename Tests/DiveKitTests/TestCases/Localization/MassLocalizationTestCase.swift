import XCTest
@testable import DiveKit

final class MassLocalizationTestCase: XCTestCase {

    func testLocalizedTitleDImperial() {
        // Given
        let unit: Mass.Unit = .pounds

        // When
        let result = unit.localizedTitle

        // Then
        XCTAssertEqual(result, "Mass")
    }

    func testLocalizedTitleMetric() {
        // Given
        let unit: Mass.Unit = .kilograms

        // When
        let result = unit.localizedTitle

        // Then
        XCTAssertEqual(result, "Mass")
    }

    func testDescriptionShortImperial() {
        // Given
        let unit: Mass.Unit = .pounds

        // When
        let result = unit.localizedDescription(for: .short)

        // Then
        XCTAssertEqual(result, "lbs")
    }

    func testDescriptionShortMetric() {
        // Given
        let unit: Mass.Unit = .kilograms

        // When
        let result = unit.localizedDescription(for: .short)

        // Then
        XCTAssertEqual(result, "km")
    }

    func testDescriptionFullImperial() {
        // Given
        let unit: Mass.Unit = .pounds

        // When
        let result = unit.localizedDescription(for: .full)

        // Then
        XCTAssertEqual(result, "pounds")
    }

    func testDescriptionFullMetric() {
        // Given
        let unit: Mass.Unit = .kilograms

        // When
        let result = unit.localizedDescription(for: .full)

        // Then
        XCTAssertEqual(result, "kilograms")
    }

    func testQuantityShortImperial() {
        // Given
        let unit: Mass.Unit = .pounds

        // When
        let result = unit.localization(for: .quantity(.zero, .short))

        // Then
        XCTAssertEqual(result, "0 lbs")
    }

    func testQuantityShortMetric() {
        // Given
        let unit: Mass.Unit = .kilograms

        // When
        let result = unit.localization(for: .quantity(.zero, .short))

        // Then
        XCTAssertEqual(result, "0 km")
    }

    func testQuantityFullImperial() {
        // Given
        let unit: Mass.Unit = .pounds

        // When
        let result = unit.localization(for: .quantity(.zero, .full))

        // Then
        XCTAssertEqual(result, "0 pounds")
    }

    func testQuantityFullMetric() {
        // Given
        let unit: Mass.Unit = .kilograms

        // When
        let result = unit.localization(for: .quantity(.zero, .full))

        // Then
        XCTAssertEqual(result, "0 kilograms")
    }
}
