import Testing
@testable import DiveKit

final class PressureLocalizationTestCase: SystemUnderTestCase<Pressure.Unit> {
    @Test
    func testLocalizedTitleDImperial() {
        // Given
        sut = .psi

        // When
        let result = sut.localizedTitle

        // Then
        expectEqual(result, "Pressure")
    }

    @Test
    func testLocalizedTitleMetric() {
        // Given
        sut = .bar

        // When
        let result = sut.localizedTitle

        // Then
        expectEqual(result, "Pressure")
    }

    @Test
    func testLocalizedTitleAtmospheres() {
        // Given
        sut = .atmospheres

        // When
        let result = sut.localizedTitle

        // Then
        expectEqual(result, "Pressure")
    }

    @Test
    func testDescriptionShortImperial() {
        // Given
        let style: LocalizationStyle = .short
        sut = .psi

        // When
        let result = sut.localizedDescription(for: style)

        // Then
        expectEqual(result, "psi")
    }

    @Test
    func testDescriptionShortMetric() {
        // Given
        let style: LocalizationStyle = .short
        sut = .bar

        // When
        let result = sut.localizedDescription(for: style)

        // Then
        expectEqual(result, "bar")
    }

    @Test
    func testDescriptionShortAtmospheres() {
        // Given
        let style: LocalizationStyle = .short
        sut = .atmospheres

        // When
        let result = sut.localizedDescription(for: style)

        // Then
        expectEqual(result, "atm")
    }

    @Test
    func testDescriptionFullImperial() {
        // Given
        let style: LocalizationStyle = .full
        sut = .psi

        // When
        let result = sut.localizedDescription(for: style)

        // Then
        expectEqual(result, "pounds per square inch")
    }

    @Test
    func testDescriptionFullMetric() {
        // Given
        let style: LocalizationStyle = .full
        sut = .bar

        // When
        let result = sut.localizedDescription(for: style)

        // Then
        expectEqual(result, "bar")
    }

    @Test
    func testDescriptionFullAtmospheres() {
        // Given
        let style: LocalizationStyle = .full
        sut = .atmospheres

        // When
        let result = sut.localizedDescription(for: style)

        // Then
        expectEqual(result, "atmospheres")
    }

    @Test
    func testQuantityShortImperial() {
        // Given
        let quantity: Double = .zero
        let style: LocalizationStyle = .short
        sut = .psi

        // When
        let result = sut.localization(for: .quantity(quantity, style))

        // Then
        expectEqual(result, "0 psi")
    }

    @Test
    func testQuantityShortMetric() {
        // Given
        let quantity: Double = .zero
        let style: LocalizationStyle = .short
        sut = .bar

        // When
        let result = sut.localization(for: .quantity(quantity, style))

        // Then
        expectEqual(result, "0 bar")
    }

    @Test
    func testQuantityShortAtmospheres() {
        // Given
        let quantity: Double = .zero
        let style: LocalizationStyle = .short
        sut = .atmospheres

        // When
        let result = sut.localization(for: .quantity(quantity, style))

        // Then
        expectEqual(result, "0 atm")
    }

    @Test
    func testQuantityFullImperial() {
        // Given
        let quantity: Double = .zero
        let style: LocalizationStyle = .full
        sut = .psi

        // When
        let result = sut.localization(for: .quantity(quantity, style))

        // Then
        expectEqual(result, "0 pounds per square inch")
    }

    @Test
    func testQuantityFullMetric() {
        // Given
        let quantity: Double = .zero
        let style: LocalizationStyle = .full
        sut = .bar

        // When
        let result = sut.localization(for: .quantity(quantity, style))

        // Then
        expectEqual(result, "0 bar")
    }

    @Test
    func testQuantityFullAtmospheres() {
        // Given
        let quantity: Double = .zero
        let style: LocalizationStyle = .full
        sut = .atmospheres

        // When
        let result = sut.localization(for: .quantity(quantity, style))

        // Then
        expectEqual(result, "0 atmospheres")
    }

    @Test
    func testOneQuantityFullImperial() {
        // Given
        let quantity: Double = 1
        let style: LocalizationStyle = .full
        sut = .psi

        // When
        let result = sut.localization(for: .quantity(quantity, style))

        // Then
        expectEqual(result, "1 pound per square inch")
    }

    @Test
    func testOneQuantityFullMetric() {
        // Given
        let quantity: Double = 1
        let style: LocalizationStyle = .full
        sut = .bar

        // When
        let result = sut.localization(for: .quantity(quantity, style))

        // Then
        expectEqual(result, "1 bar")
    }

    @Test
    func testOneQuantityFullAtmospheres() {
        // Given
        let quantity: Double = 1
        let style: LocalizationStyle = .full
        sut = .atmospheres

        // When
        let result = sut.localization(for: .quantity(quantity, style))

        // Then
        expectEqual(result, "1 atmosphere")
    }
}
