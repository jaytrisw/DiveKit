import Foundation
import Testing
@testable import DiveKit

@Suite
struct DepthFormatStyleTests {
    @Test func formatStyle() {
        withTestLocalization(.test) {
            // Given
            let sut = Depth(15)

            // When
            let result = sut.formatted(.depth(.feet, style: .full))

            // Then
            #expect(result == "15 feet")
        }
    }

    @Test func germanShortFormatStyleUsesLocaleDecimalSeparator() {
        withTestLocalization(.test) {
            // Given
            let sut = Depth(33)

            // When
            let result = sut.formatted(.depth(.feet, style: .short).locale(Locale(identifier: "de_DE")))

            // Then
            #expect(result == "33 ft")
            #expect(result != "33,000 ft")
        }
    }

    @Test func germanShortFormatStyleUsesExplicitPrecision() {
        withTestLocalization(.test) {
            // Given
            let sut = Depth(33)

            // When
            let result = sut.formatted(
                .depth(.feet, style: .short)
                    .precision(.fractionLength(1))
                    .locale(Locale(identifier: "de_DE")))

            // Then
            #expect(result == "33,0 ft")
        }
    }

    @Test func germanMetricShortFormatStylePreservesMeaningfulDecimalDigit() {
        withTestLocalization(.test) {
            // Given
            let sut = Depth(10.3)

            // When
            let result = sut.formatted(
                .depth(.meters, style: .short)
                    .precision(.fractionLength(1))
                    .locale(Locale(identifier: "de_DE")))

            // Then
            #expect(result == "10,3 m")
        }
    }

    @Test func englishShortFormatStyleUsesExplicitPrecision() {
        withTestLocalization(.test) {
            // Given
            let sut = Depth(33)

            // When
            let result = sut.formatted(
                .depth(.feet, style: .short)
                    .precision(.fractionLength(1))
                    .locale(Locale.english))

            // Then
            #expect(result == "33.0 ft")
        }
    }

    @Test func fullFormatStylePreservesSingularAndPluralUnits() {
        withTestLocalization(.test) {
            // Given
            let locale = Locale.english
            let data: [DepthFormatStyleExpectation] = [
                .init(input: Depth(1), style: .depth(.feet, style: .full).locale(locale), output: "1 foot"),
                .init(input: Depth(2), style: .depth(.feet, style: .full).locale(locale), output: "2 feet"),
                .init(input: Depth(1), style: .depth(.meters, style: .full).locale(locale), output: "1 meter"),
                .init(input: Depth(2), style: .depth(.meters, style: .full).locale(locale), output: "2 meters")
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

private struct DepthFormatStyleExpectation {
    let input: Depth
    let style: DecimalUnitFormatStyle<Depth>
    let output: String
}
