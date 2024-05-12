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
        sut = .cubicFeet

        // When
        let result = sut.localizedDescription(for: .short)

        // Then
        XCTAssertEqual(result, "cu ft")
    }

    func testDescriptionShortMetric() {
        // Given
        sut = .liters

        // When
        let result = sut.localizedDescription(for: .short)

        // Then
        XCTAssertEqual(result, "l")
    }

    func testDescriptionFullImperial() {
        // Given
        sut = .cubicFeet

        // When
        let result = sut.localizedDescription(for: .full)

        // Then
        XCTAssertEqual(result, "cubic feet")
    }

    func testDescriptionFullMetric() {
        // Given
        sut = .liters

        // When
        let result = sut.localizedDescription(for: .full)

        // Then
        XCTAssertEqual(result, "liters")
    }

    func testQuantityShortImperial() {
        // Given
        sut = .cubicFeet

        // When
        let result = sut.localization(for: .quantity(.zero, .short))

        // Then
        XCTAssertEqual(result, "0.000 cu ft")
    }

    func testQuantityShortMetric() {
        // Given
        sut = .liters

        // When
        let result = sut.localization(for: .quantity(.zero, .short))

        // Then
        XCTAssertEqual(result, "0.000 l")
    }

    func testQuantityFullImperial() {
        // Given
        sut = .cubicFeet

        // When
        let result = sut.localization(for: .quantity(.zero, .full))

        // Then
        XCTAssertEqual(result, "0.000 cubic feet")
    }

    func testQuantityFullMetric() {
        // Given
        sut = .liters

        // When
        let result = sut.localization(for: .quantity(.zero, .full))

        // Then
        XCTAssertEqual(result, "0.000 liters")
    }

    func testOneQuantityFullImperial() {
        // Given
        sut = .cubicFeet

        // When
        let result = sut.localization(for: .quantity(1, .full))

        // Then
        XCTAssertEqual(result, "1.000 cubic foot")
    }

    func testOneQuantityFullMetric() {
        // Given
        sut = .liters

        // When
        let result = sut.localization(for: .quantity(1, .full))

        // Then
        XCTAssertEqual(result, "1.000 liter")
    }
}
