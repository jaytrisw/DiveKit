import XCTest
@testable import DiveKit

final class DepthLocalizationTestCase: XCTestCase {

    func testLocalizedTitleDImperial() {
        // Given
        let unit: Depth.Unit = .feet

        // When
        let result = unit.localizedTitle

        // Then
        XCTAssertEqual(result, "Depth")
    }

    func testLocalizedTitleMetric() {
        // Given
        let unit: Depth.Unit = .meters

        // When
        let result = unit.localizedTitle

        // Then
        XCTAssertEqual(result, "Depth")
    }

    func testDescriptionShortImperial() {
        // Given
        let unit: Depth.Unit = .feet

        // When
        let result = unit.localizedDescription(for: .short)

        // Then
        XCTAssertEqual(result, "ft")
    }

    func testDescriptionShortMetric() {
        // Given
        let unit: Depth.Unit = .meters

        // When
        let result = unit.localizedDescription(for: .short)

        // Then
        XCTAssertEqual(result, "m")
    }

    func testDescriptionFullImperial() {
        // Given
        let unit: Depth.Unit = .feet

        // When
        let result = unit.localizedDescription(for: .full)

        // Then
        XCTAssertEqual(result, "feet")
    }

    func testDescriptionFullMetric() {
        // Given
        let unit: Depth.Unit = .meters

        // When
        let result = unit.localizedDescription(for: .full)

        // Then
        XCTAssertEqual(result, "meters")
    }

    func testQuantityShortImperial() {
        // Given
        let unit: Depth.Unit = .feet

        // When
        let result = unit.localization(for: .quantity(.zero, .short))

        // Then
        XCTAssertEqual(result, "0 ft")
    }

    func testQuantityShortMetric() {
        // Given
        let unit: Depth.Unit = .meters

        // When
        let result = unit.localization(for: .quantity(.zero, .short))

        // Then
        XCTAssertEqual(result, "0 m")
    }

    func testQuantityFullImperial() {
        // Given
        let unit: Depth.Unit = .feet

        // When
        let result = unit.localization(for: .quantity(.zero, .full))

        // Then
        XCTAssertEqual(result, "0 feet")
    }

    func testQuantityFullMetric() {
        // Given
        let unit: Depth.Unit = .meters

        // When
        let result = unit.localization(for: .quantity(.zero, .full))

        // Then
        XCTAssertEqual(result, "0 meters")
    }
}
