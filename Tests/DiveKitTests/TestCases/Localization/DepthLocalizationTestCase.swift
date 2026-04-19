import Testing
@testable import DiveKit

final class DepthLocalizationTestCase: SystemUnderTestCase<Depth.Unit> {
    @Test
    func testLocalizedTitleDImperial() {
        // Given
        sut = .feet

        // When
        let result = sut.localizedTitle

        // Then
        #expect(result == "Depth")
    }

    @Test
    func testLocalizedTitleMetric() {
        // Given
        sut = .meters

        // When
        let result = sut.localizedTitle

        // Then
        #expect(result == "Depth")
    }

    @Test
    func testDescriptionShortImperial() {
        // Given
        let style: LocalizationStyle = .short
        sut = .feet

        // When
        let result = sut.localizedDescription(for: style)

        // Then
        #expect(result == "ft")
    }

    @Test
    func testDescriptionShortMetric() {
        // Given
        let style: LocalizationStyle = .short
        sut = .meters

        // When
        let result = sut.localizedDescription(for: style)

        // Then
        #expect(result == "m")
    }

    @Test
    func testDescriptionFullImperial() {
        // Given
        let style: LocalizationStyle = .full
        sut = .feet

        // When
        let result = sut.localizedDescription(for: style)

        // Then
        #expect(result == "feet")
    }

    @Test
    func testDescriptionFullMetric() {
        // Given
        let style: LocalizationStyle = .full
        sut = .meters

        // When
        let result = sut.localizedDescription(for: style)

        // Then
        #expect(result == "meters")
    }

    @Test
    func testQuantityShortImperial() {
        // Given
        let quantity: Double = .zero
        let style: LocalizationStyle = .short
        sut = .feet

        // When
        let result = sut.localization(for: .quantity(quantity, style))

        // Then
        #expect(result == "0 ft")
    }

    @Test
    func testQuantityShortMetric() {
        // Given
        let quantity: Double = .zero
        let style: LocalizationStyle = .short
        sut = .meters

        // When
        let result = sut.localization(for: .quantity(quantity, style))

        // Then
        #expect(result == "0 m")
    }

    @Test
    func testQuantityFullImperial() {
        // Given
        let quantity: Double = .zero
        let style: LocalizationStyle = .full
        sut = .feet

        // When
        let result = sut.localization(for: .quantity(quantity, style))

        // Then
        #expect(result == "0 feet")
    }

    @Test
    func testQuantityFullMetric() {
        // Given
        let quantity: Double = .zero
        let style: LocalizationStyle = .full
        sut = .meters

        // When
        let result = sut.localization(for: .quantity(quantity, style))

        // Then
        #expect(result == "0 meters")
    }

    @Test
    func testOneQuantityFullImperial() {
        // Given
        let quantity: Double = 1
        let style: LocalizationStyle = .full
        sut = .feet

        // When
        let result = sut.localization(for: .quantity(quantity, style))

        // Then
        #expect(result == "1 foot")
    }

    @Test
    func testOneQuantityFullMetric() {
        // Given
        let quantity: Double = 1
        let style: LocalizationStyle = .full
        sut = .meters

        // When
        let result = sut.localization(for: .quantity(quantity, style))

        // Then
        #expect(result == "1 meter")
    }
}
