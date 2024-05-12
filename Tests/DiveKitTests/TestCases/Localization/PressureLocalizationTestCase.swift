import XCTest
@testable import DiveKit

final class PressureLocalizationTestCase: XCTestCase {

    func testLocalizedTitleDImperial() {
        // Given
        let unit: Pressure.Unit = .psi

        // When
        let result = unit.localizedTitle

        // Then
        XCTAssertEqual(result, "Pressure")
    }

    func testLocalizedTitleMetric() {
        // Given
        let unit: Pressure.Unit = .bar

        // When
        let result = unit.localizedTitle

        // Then
        XCTAssertEqual(result, "Pressure")
    }

    func testLocalizedTitleAtmospheres() {
        // Given
        let unit: Pressure.Unit = .atmospheres

        // When
        let result = unit.localizedTitle

        // Then
        XCTAssertEqual(result, "Pressure")
    }

    func testDescriptionShortImperial() {
        // Given
        let unit: Pressure.Unit = .psi

        // When
        let result = unit.localizedDescription(for: .short)

        // Then
        XCTAssertEqual(result, "psi")
    }

    func testDescriptionShortMetric() {
        // Given
        let unit: Pressure.Unit = .bar

        // When
        let result = unit.localizedDescription(for: .short)

        // Then
        XCTAssertEqual(result, "bar")
    }

    func testDescriptionShortAtmospheres() {
        // Given
        let unit: Pressure.Unit = .atmospheres

        // When
        let result = unit.localizedDescription(for: .short)

        // Then
        XCTAssertEqual(result, "atm")
    }

    func testDescriptionFullImperial() {
        // Given
        let unit: Pressure.Unit = .psi

        // When
        let result = unit.localizedDescription(for: .full)

        // Then
        XCTAssertEqual(result, "pounds per square inch")
    }

    func testDescriptionFullMetric() {
        // Given
        let unit: Pressure.Unit = .bar

        // When
        let result = unit.localizedDescription(for: .full)

        // Then
        XCTAssertEqual(result, "bar")
    }

    func testDescriptionFullAtmospheres() {
        // Given
        let unit: Pressure.Unit = .atmospheres

        // When
        let result = unit.localizedDescription(for: .full)

        // Then
        XCTAssertEqual(result, "atmospheres")
    }

    func testQuantityShortImperial() {
        // Given
        let unit: Pressure.Unit = .psi

        // When
        let result = unit.localization(for: .quantity(.zero, .short))

        // Then
        XCTAssertEqual(result, "0 psi")
    }

    func testQuantityShortMetric() {
        // Given
        let unit: Pressure.Unit = .bar

        // When
        let result = unit.localization(for: .quantity(.zero, .short))

        // Then
        XCTAssertEqual(result, "0 bar")
    }

    func testQuantityShortAtmospheres() {
        // Given
        let unit: Pressure.Unit = .atmospheres

        // When
        let result = unit.localization(for: .quantity(.zero, .short))

        // Then
        XCTAssertEqual(result, "0 atm")
    }

    func testQuantityFullImperial() {
        // Given
        let unit: Pressure.Unit = .psi

        // When
        let result = unit.localization(for: .quantity(.zero, .full))

        // Then
        XCTAssertEqual(result, "0 pounds per square inch")
    }

    func testQuantityFullMetric() {
        // Given
        let unit: Pressure.Unit = .bar

        // When
        let result = unit.localization(for: .quantity(.zero, .full))

        // Then
        XCTAssertEqual(result, "0 bar")
    }

    func testQuantityFullAtmospheres() {
        // Given
        let unit: Pressure.Unit = .atmospheres

        // When
        let result = unit.localization(for: .quantity(.zero, .full))

        // Then
        XCTAssertEqual(result, "0 atmospheres")
    }
}
