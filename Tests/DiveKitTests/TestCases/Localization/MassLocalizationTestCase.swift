import Testing
@testable import DiveKit

final class MassLocalizationTestCase: SystemUnderTestCase<Mass.Unit> {
    @Test
    func testLocalizedTitleDImperial() {
        // Given
        sut = .pounds

        // When
        let result = sut.localizedTitle

        // Then
        #expect(result == "Mass")
    }

    @Test
    func testLocalizedTitleMetric() {
        // Given
        sut = .kilograms

        // When
        let result = sut.localizedTitle

        // Then
        #expect(result == "Mass")
    }

    @Test
    func testDescriptionShortImperial() {
        // Given
        let style: LocalizationStyle = .short
        sut = .pounds

        // When
        let result = sut.localizedDescription(for: style)

        // Then
        #expect(result == "lbs")
    }

    @Test
    func testDescriptionShortMetric() {
        // Given
        let style: LocalizationStyle = .short
        sut = .kilograms

        // When
        let result = sut.localizedDescription(for: style)

        // Then
        #expect(result == "kg")
    }

    @Test
    func testDescriptionFullImperial() {
        // Given
        let style: LocalizationStyle = .full
        sut = .pounds

        // When
        let result = sut.localizedDescription(for: style)

        // Then
        #expect(result == "pounds")
    }

    @Test
    func testDescriptionFullMetric() {
        // Given
        let style: LocalizationStyle = .full
        sut = .kilograms

        // When
        let result = sut.localizedDescription(for: style)

        // Then
        #expect(result == "kilograms")
    }

    @Test
    func testQuantityShortImperial() {
        // Given
        let quantity: Double = .zero
        let style: LocalizationStyle = .short
        sut = .pounds

        // When
        let result = sut.localization(for: .quantity(quantity, style))

        // Then
        #expect(result == "0 lbs")
    }

    @Test
    func testQuantityShortMetric() {
        // Given
        let quantity: Double = .zero
        let style: LocalizationStyle = .short
        sut = .kilograms

        // When
        let result = sut.localization(for: .quantity(quantity, style))

        // Then
        #expect(result == "0 kg")
    }

    @Test
    func testQuantityFullImperial() {
        // Given
        let quantity: Double = .zero
        let style: LocalizationStyle = .full
        sut = .pounds

        // When
        let result = sut.localization(for: .quantity(quantity, style))

        // Then
        #expect(result == "0 pounds")
    }

    @Test
    func testQuantityFullMetric() {
        // Given
        let quantity: Double = .zero
        let style: LocalizationStyle = .full
        sut = .kilograms

        // When
        let result = sut.localization(for: .quantity(quantity, style))

        // Then
        #expect(result == "0 kilograms")
    }

    @Test
    func testOneQuantityFullImperial() {
        // Given
        let quantity: Double = 1
        let style: LocalizationStyle = .full
        sut = .pounds

        // When
        let result = sut.localization(for: .quantity(quantity, style))

        // Then
        #expect(result == "1 pound")
    }

    @Test
    func testOneQuantityFullMetric() {
        // Given
        let quantity: Double = 1
        let style: LocalizationStyle = .full
        sut = .kilograms

        // When
        let result = sut.localization(for: .quantity(quantity, style))

        // Then
        #expect(result == "1 kilogram")
    }
}
