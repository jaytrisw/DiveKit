import XCTest
@testable import DiveKit

final class VolumeLocalizationTestCase: XCTestCase {

    func testLocalizedTitleDImperial() {
        // Given
        let unit: Volume.Unit = .cubicFeet

        // When
        let result = unit.localizedTitle

        // Then
        XCTAssertEqual(result, "Volume")
    }

    func testLocalizedTitleMetric() {
        // Given
        let unit: Volume.Unit = .liters

        // When
        let result = unit.localizedTitle

        // Then
        XCTAssertEqual(result, "Volume")
    }

    func testDescriptionShortImperial() {
        // Given
        let unit: Volume.Unit = .cubicFeet

        // When
        let result = unit.localizedDescription(for: .short)

        // Then
        XCTAssertEqual(result, "cu ft")
    }

    func testDescriptionShortMetric() {
        // Given
        let unit: Volume.Unit = .liters

        // When
        let result = unit.localizedDescription(for: .short)

        // Then
        XCTAssertEqual(result, "l")
    }

    func testDescriptionFullImperial() {
        // Given
        let unit: Volume.Unit = .cubicFeet

        // When
        let result = unit.localizedDescription(for: .full)

        // Then
        XCTAssertEqual(result, "cubic feet")
    }

    func testDescriptionFullMetric() {
        // Given
        let unit: Volume.Unit = .liters

        // When
        let result = unit.localizedDescription(for: .full)

        // Then
        XCTAssertEqual(result, "liters")
    }

    func testQuantityShortImperial() {
        // Given
        let unit: Volume.Unit = .cubicFeet

        // When
        let result = unit.localization(for: .quantity(.zero, .short))

        // Then
        XCTAssertEqual(result, "0 cu ft")
    }

    func testQuantityShortMetric() {
        // Given
        let unit: Volume.Unit = .liters

        // When
        let result = unit.localization(for: .quantity(.zero, .short))

        // Then
        XCTAssertEqual(result, "0 l")
    }

    func testQuantityFullImperial() {
        // Given
        let unit: Volume.Unit = .cubicFeet

        // When
        let result = unit.localization(for: .quantity(.zero, .full))

        // Then
        XCTAssertEqual(result, "0 cubic feet")
    }

    func testQuantityFullMetric() {
        // Given
        let unit: Volume.Unit = .liters

        // When
        let result = unit.localization(for: .quantity(.zero, .full))

        // Then
        XCTAssertEqual(result, "0 liters")
    }
}
