import Foundation
import Testing
@testable import DiveKit

@Suite(.tags(.localization))
struct MassFormatStyleTests {
    @Test func formatStyle() {
        withTestLocalization(.test) {
            // Given
            let sut = Mass(15)

            // When
            let result = sut.formatted(.mass(.pounds, style: .full))

            // Then
            #expect(result == "15 pounds")
        }
    }

    @Test func germanShortFormatStyleUsesExplicitPrecision() {
        withTestLocalization(.test) {
            // Given
            let sut = Mass(33)

            // When
            let result = sut.formatted(
                .mass(.pounds, style: .short)
                    .precision(.fractionLength(1))
                    .locale(Locale(identifier: "de_DE")))

            // Then
            #expect(result == "33,0 lbs")
        }
    }

    @Test func germanMetricShortFormatStylePreservesMeaningfulDecimalDigit() {
        withTestLocalization(.test) {
            // Given
            let sut = Mass(10.3)

            // When
            let result = sut.formatted(
                .mass(.kilograms, style: .short)
                    .precision(.fractionLength(1))
                    .locale(Locale(identifier: "de_DE")))

            // Then
            #expect(result == "10,3 kg")
        }
    }

    @Test func englishShortFormatStyleUsesExplicitPrecision() {
        withTestLocalization(.test) {
            // Given
            let sut = Mass(33)

            // When
            let result = sut.formatted(
                .mass(.pounds, style: .short)
                    .precision(.fractionLength(1))
                    .locale(Locale.english))

            // Then
            #expect(result == "33.0 lbs")
        }
    }

    @Test func fullFormatStylePreservesSingularAndPluralUnits() {
        withTestLocalization(.test) {
            // Given
            let locale = Locale.english
            let data: [MassFormatStyleExpectation] = [
                .init(input: Mass(1), style: .mass(.pounds, style: .full).locale(locale), output: "1 pound"),
                .init(input: Mass(2), style: .mass(.pounds, style: .full).locale(locale), output: "2 pounds"),
                .init(input: Mass(1), style: .mass(.kilograms, style: .full).locale(locale), output: "1 kilogram"),
                .init(input: Mass(2), style: .mass(.kilograms, style: .full).locale(locale), output: "2 kilograms")
            ]

            for datum in data {
                // When
                let result = datum.input.formatted(datum.style)

                // Then
                #expect(result == datum.output)
            }
        }
    }
}

private struct MassFormatStyleExpectation {
    let input: Mass
    let style: DecimalUnitFormatStyle<Mass>
    let output: String
}
