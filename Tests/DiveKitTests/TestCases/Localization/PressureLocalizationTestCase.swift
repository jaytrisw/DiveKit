import XCTest
@testable import DiveKit

final class PressureLocalizationTestCase: SystemUnderTestCase<Pressure.Unit> {

    func testLocalizedTitleDImperial() {
        // Given
        sut = .psi

        // When
        let result = sut.localizedTitle

        // Then
        XCTAssertEqual(result, "Pressure")
    }

    func testLocalizedTitleMetric() {
        // Given
        sut = .bar

        // When
        let result = sut.localizedTitle

        // Then
        XCTAssertEqual(result, "Pressure")
    }

    func testLocalizedTitleAtmospheres() {
        // Given
        sut = .atmospheres

        // When
        let result = sut.localizedTitle

        // Then
        XCTAssertEqual(result, "Pressure")
    }

    func testDescriptionShortImperial() {
        // Given
        sut = .psi

        // When
        let result = sut.localizedDescription(for: .short)

        // Then
        XCTAssertEqual(result, "psi")
    }

    func testDescriptionShortMetric() {
        // Given
        sut = .bar

        // When
        let result = sut.localizedDescription(for: .short)

        // Then
        XCTAssertEqual(result, "bar")
    }

    func testDescriptionShortAtmospheres() {
        // Given
        sut = .atmospheres

        // When
        let result = sut.localizedDescription(for: .short)

        // Then
        XCTAssertEqual(result, "atm")
    }

    func testDescriptionFullImperial() {
        // Given
        sut = .psi

        // When
        let result = sut.localizedDescription(for: .full)

        // Then
        XCTAssertEqual(result, "pounds per square inch")
    }

    func testDescriptionFullMetric() {
        // Given
        sut = .bar

        // When
        let result = sut.localizedDescription(for: .full)

        // Then
        XCTAssertEqual(result, "bar")
    }

    func testDescriptionFullAtmospheres() {
        // Given
        sut = .atmospheres

        // When
        let result = sut.localizedDescription(for: .full)

        // Then
        XCTAssertEqual(result, "atmospheres")
    }

    func testQuantityShortImperial() {
        // Given
        sut = .psi

        // When
        let result = sut.localization(for: .quantity(.zero, .short))

        // Then
        XCTAssertEqual(result, "0 psi")
    }

    func testQuantityShortMetric() {
        // Given
        sut = .bar

        // When
        let result = sut.localization(for: .quantity(.zero, .short))

        // Then
        XCTAssertEqual(result, "0 bar")
    }

    func testQuantityShortAtmospheres() {
        // Given
        sut = .atmospheres

        // When
        let result = sut.localization(for: .quantity(.zero, .short))

        // Then
        XCTAssertEqual(result, "0 atm")
    }

    func testQuantityFullImperial() {
        // Given
        sut = .psi

        // When
        let result = sut.localization(for: .quantity(.zero, .full))

        // Then
        XCTAssertEqual(result, "0 pounds per square inch")
    }

    func testQuantityFullMetric() {
        // Given
        sut = .bar

        // When
        let result = sut.localization(for: .quantity(.zero, .full))

        // Then
        XCTAssertEqual(result, "0 bar")
    }

    func testQuantityFullAtmospheres() {
        // Given
        sut = .atmospheres

        // When
        let result = sut.localization(for: .quantity(.zero, .full))

        // Then
        XCTAssertEqual(result, "0 atmospheres")
    }

    func testOneQuantityFullImperial() {
        // Given
        sut = .psi

        // When
        let result = sut.localization(for: .quantity(1, .full))

        // Then
        XCTAssertEqual(result, "1 pound per square inch")
    }

    func testOneQuantityFullMetric() {
        // Given
        sut = .bar

        // When
        let result = sut.localization(for: .quantity(1, .full))

        // Then
        XCTAssertEqual(result, "1 bar")
    }

    func testOneQuantityFullAtmospheres() {
        // Given
        sut = .atmospheres

        // When
        let result = sut.localization(for: .quantity(1, .full))

        // Then
        XCTAssertEqual(result, "1 atmosphere")
    }
}
