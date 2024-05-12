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
        sut = .feet

        // When
        let result = sut.localizedDescription(for: .short)

        // Then
        XCTAssertEqual(result, "ft")
    }

    func testDescriptionShortMetric() {
        // Given
        sut = .meters

        // When
        let result = sut.localizedDescription(for: .short)

        // Then
        XCTAssertEqual(result, "m")
    }

    func testDescriptionFullImperial() {
        // Given
        sut = .feet

        // When
        let result = sut.localizedDescription(for: .full)

        // Then
        XCTAssertEqual(result, "feet")
    }

    func testDescriptionFullMetric() {
        // Given
        sut = .meters

        // When
        let result = sut.localizedDescription(for: .full)

        // Then
        XCTAssertEqual(result, "meters")
    }

    func testQuantityShortImperial() {
        // Given
        sut = .feet

        // When
        let result = sut.localization(for: .quantity(.zero, .short))

        // Then
        XCTAssertEqual(result, "0 ft")
    }

    func testQuantityShortMetric() {
        // Given
        sut = .meters

        // When
        let result = sut.localization(for: .quantity(.zero, .short))

        // Then
        XCTAssertEqual(result, "0 m")
    }

    func testQuantityFullImperial() {
        // Given
        sut = .feet

        // When
        let result = sut.localization(for: .quantity(.zero, .full))

        // Then
        XCTAssertEqual(result, "0 feet")
    }

    func testQuantityFullMetric() {
        // Given
        sut = .meters

        // When
        let result = sut.localization(for: .quantity(.zero, .full))

        // Then
        XCTAssertEqual(result, "0 meters")
    }

    func testOneQuantityFullImperial() {
        // Given
        sut = .feet

        // When
        let result = sut.localization(for: .quantity(1, .full))

        // Then
        XCTAssertEqual(result, "1 foot")
    }

    func testOneQuantityFullMetric() {
        // Given
        sut = .meters

        // When
        let result = sut.localization(for: .quantity(1, .full))

        // Then
        XCTAssertEqual(result, "1 meter")
    }
}
