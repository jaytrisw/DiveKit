import Foundation
import Testing
@testable import DiveKit

@Suite
struct RateFormatStyleTests {
    @Test func formatStyle() {
        withTestLocalization(.test) {
            // Given
            let sut = Rate<Pressure>(15)

            // When
            let result = sut.formatted(.rate(.perMinute(.psi), style: .full))

            // Then
            #expect(result == "15 pounds per square inch per minute")
        }
    }

    @Test func germanShortFormatStyleUsesExplicitPrecision() {
        withTestLocalization(.test) {
            // Given
            let sut = Rate<Depth>(33)

            // When
            let result = sut.formatted(
                .rate(.perMinute(.feet), style: .short)
                    .precision(.fractionLength(1))
                    .locale(Locale(identifier: "de_DE")))

            // Then
            #expect(result == "33,0 ft/min")
        }
    }

    @Test func germanMetricShortFormatStylePreservesMeaningfulDecimalDigit() {
        withTestLocalization(.test) {
            // Given
            let sut = Rate<Depth>(10.3)

            // When
            let result = sut.formatted(
                .rate(.perMinute(.meters), style: .short)
                    .precision(.fractionLength(1))
                    .locale(Locale(identifier: "de_DE")))

            // Then
            #expect(result == "10,3 m/min")
        }
    }

    @Test func englishShortFormatStyleUsesExplicitPrecision() {
        withTestLocalization(.test) {
            // Given
            let sut = Rate<Depth>(33)

            // When
            let result = sut.formatted(
                .rate(.perMinute(.feet), style: .short)
                    .precision(.fractionLength(1))
                    .locale(Locale.english))

            // Then
            #expect(result == "33.0 ft/min")
        }
    }

    @Test func fullFormatStylePreservesBaseUnitSingularAndPluralUnits() {
        withTestLocalization(.test) {
            // Given
            let locale = Locale.english
            let singular = Rate<Pressure>(1)
            let plural = Rate<Pressure>(2)

            // When
            let singularResult = singular.formatted(
                .rate(.perMinute(.psi), style: .full).locale(locale))
            let pluralResult = plural.formatted(
                .rate(.perMinute(.psi), style: .full).locale(locale))

            // Then
            #expect(singularResult == "1 pound per square inch per minute")
            #expect(pluralResult == "2 pounds per square inch per minute")
        }
    }
}
