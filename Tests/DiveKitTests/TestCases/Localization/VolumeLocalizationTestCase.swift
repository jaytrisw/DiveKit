import Testing
@testable import DiveKit

final class VolumeLocalizationTestCase: SystemUnderTestCase<Volume.Unit> {
    @Test
    func testLocalizedTitleDImperial() {
        // Given
        sut = .cubicFeet

        // When
        let result = sut.localizedTitle

        // Then
        #expect(result == "Volume")
    }

    @Test
    func testLocalizedTitleMetric() {
        // Given
        sut = .liters

        // When
        let result = sut.localizedTitle

        // Then
        #expect(result == "Volume")
    }

    @Test
    func testDescriptionShortImperial() {
        // Given
        let style: LocalizationStyle = .short
        sut = .cubicFeet

        // When
        let result = sut.localizedDescription(for: style)

        // Then
        #expect(result == "cu ft")
    }

    @Test
    func testDescriptionShortMetric() {
        // Given
        let style: LocalizationStyle = .short
        sut = .liters

        // When
        let result = sut.localizedDescription(for: style)

        // Then
        #expect(result == "l")
    }

    @Test
    func testDescriptionFullImperial() {
        // Given
        let style: LocalizationStyle = .full
        sut = .cubicFeet

        // When
        let result = sut.localizedDescription(for: style)

        // Then
        #expect(result == "cubic feet")
    }

    @Test
    func testDescriptionFullMetric() {
        // Given
        let style: LocalizationStyle = .full
        sut = .liters

        // When
        let result = sut.localizedDescription(for: style)

        // Then
        #expect(result == "liters")
    }

    @Test
    func testQuantityShortImperial() {
        // Given
        let quantity: Double = .zero
        let style: LocalizationStyle = .short
        sut = .cubicFeet

        // When
        let result = sut.localization(for: .quantity(quantity, style))

        // Then
        #expect(result == "0 cu ft")
    }

    @Test
    func testQuantityShortMetric() {
        // Given
        let quantity: Double = .zero
        let style: LocalizationStyle = .short
        sut = .liters

        // When
        let result = sut.localization(for: .quantity(quantity, style))

        // Then
        #expect(result == "0 l")
    }

    @Test
    func testQuantityFullImperial() {
        // Given
        let quantity: Double = .zero
        let style: LocalizationStyle = .full
        sut = .cubicFeet

        // When
        let result = sut.localization(for: .quantity(quantity, style))

        // Then
        #expect(result == "0 cubic feet")
    }

    @Test
    func testQuantityFullMetric() {
        // Given
        let quantity: Double = .zero
        let style: LocalizationStyle = .full
        sut = .liters

        // When
        let result = sut.localization(for: .quantity(quantity, style))

        // Then
        #expect(result == "0 liters")
    }

    @Test
    func testOneQuantityFullImperial() {
        // Given
        let quantity: Double = 1
        let style: LocalizationStyle = .full
        sut = .cubicFeet

        // When
        let result = sut.localization(for: .quantity(quantity, style))

        // Then
        #expect(result == "1 cubic foot")
    }

    @Test
    func testOneQuantityFullMetric() {
        // Given
        let quantity: Double = 1
        let style: LocalizationStyle = .full
        sut = .liters

        // When
        let result = sut.localization(for: .quantity(quantity, style))

        // Then
        #expect(result == "1 liter")
    }
}
