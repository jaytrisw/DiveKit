import Testing
@testable import DiveKit

@Suite
struct MassLocalizationTests {
    @Test func localizedTitleDImperial() {
        withTestLocalization(.test) {
            // Given
            let sut = Mass.Unit.pounds

            // When
            let result = sut.localizedTitle

            // Then
            #expect(result == "Mass")
        }
    }

    @Test func localizedTitleMetric() {
        withTestLocalization(.test) {
            // Given
            let sut = Mass.Unit.kilograms

            // When
            let result = sut.localizedTitle

            // Then
            #expect(result == "Mass")
        }
    }

    @Test func descriptionShortImperial() {
        withTestLocalization(.test) {
            // Given
            let sut = Mass.Unit.pounds

            // When
            let result = sut.localizedDescription(for: .short)

            // Then
            #expect(result == "lbs")
        }
    }

    @Test func descriptionShortMetric() {
        withTestLocalization(.test) {
            // Given
            let sut = Mass.Unit.kilograms

            // When
            let result = sut.localizedDescription(for: .short)

            // Then
            #expect(result == "kg")
        }
    }

    @Test func descriptionFullImperial() {
        withTestLocalization(.test) {
            // Given
            let sut = Mass.Unit.pounds

            // When
            let result = sut.localizedDescription(for: .full)

            // Then
            #expect(result == "pounds")
        }
    }

    @Test func descriptionFullMetric() {
        withTestLocalization(.test) {
            // Given
            let sut = Mass.Unit.kilograms

            // When
            let result = sut.localizedDescription(for: .full)

            // Then
            #expect(result == "kilograms")
        }
    }

    @Test func quantityShortImperial() {
        withTestLocalization(.test) {
            // Given
            let sut = Mass.Unit.pounds

            // When
            let result = sut.localization(for: .quantity(.zero, .short))

            // Then
            #expect(result == "0 lbs")
        }
    }

    @Test func quantityShortMetric() {
        withTestLocalization(.test) {
            // Given
            let sut = Mass.Unit.kilograms

            // When
            let result = sut.localization(for: .quantity(.zero, .short))

            // Then
            #expect(result == "0 kg")
        }
    }

    @Test func quantityFullImperial() {
        withTestLocalization(.test) {
            // Given
            let sut = Mass.Unit.pounds

            // When
            let result = sut.localization(for: .quantity(.zero, .full))

            // Then
            #expect(result == "0 pounds")
        }
    }

    @Test func quantityFullMetric() {
        withTestLocalization(.test) {
            // Given
            let sut = Mass.Unit.kilograms

            // When
            let result = sut.localization(for: .quantity(.zero, .full))

            // Then
            #expect(result == "0 kilograms")
        }
    }

    @Test func oneQuantityFullImperial() {
        withTestLocalization(.test) {
            // Given
            let sut = Mass.Unit.pounds

            // When
            let result = sut.localization(for: .quantity(1, .full))

            // Then
            #expect(result == "1 pound")
        }
    }

    @Test func oneQuantityFullMetric() {
        withTestLocalization(.test) {
            // Given
            let sut = Mass.Unit.kilograms

            // When
            let result = sut.localization(for: .quantity(1, .full))

            // Then
            #expect(result == "1 kilogram")
        }
    }
}
