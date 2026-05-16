import Foundation
import Testing
@testable import DiveKit

@Suite
struct VolumeFormatStyleTests {
    @Test func formatStyle() {
        withTestLocalization(.test) {
            // Given
            let sut = Volume(15)

            // When
            let result = sut.formatted(.volume(.cubicFeet, style: .full))

            // Then
            #expect(result == "15 cubic feet")
        }
    }

    @Test func germanShortFormatStyleUsesExplicitPrecision() {
        withTestLocalization(.test) {
            // Given
            let sut = Volume(33)

            // When
            let result = sut.formatted(
                .volume(.cubicFeet, style: .short)
                    .precision(.fractionLength(1))
                    .locale(Locale(identifier: "de_DE")))

            // Then
            #expect(result == "33,0 cu ft")
        }
    }

    @Test func germanMetricShortFormatStylePreservesMeaningfulDecimalDigit() {
        withTestLocalization(.test) {
            // Given
            let sut = Volume(10.3)

            // When
            let result = sut.formatted(
                .volume(.liters, style: .short)
                    .precision(.fractionLength(1))
                    .locale(Locale(identifier: "de_DE")))

            // Then
            #expect(result == "10,3 l")
        }
    }

    @Test func englishShortFormatStyleUsesExplicitPrecision() {
        withTestLocalization(.test) {
            // Given
            let sut = Volume(33)

            // When
            let result = sut.formatted(
                .volume(.cubicFeet, style: .short)
                    .precision(.fractionLength(1))
                    .locale(Locale.english))

            // Then
            #expect(result == "33.0 cu ft")
        }
    }

    @Test func fullFormatStylePreservesSingularAndPluralUnits() {
        withTestLocalization(.test) {
            // Given
            let locale = Locale.english
            let data: [VolumeFormatStyleExpectation] = [
                .init(input: Volume(1), style: .volume(.cubicFeet, style: .full).locale(locale), output: "1 cubic foot"),
                .init(input: Volume(2), style: .volume(.cubicFeet, style: .full).locale(locale), output: "2 cubic feet"),
                .init(input: Volume(1), style: .volume(.liters, style: .full).locale(locale), output: "1 liter"),
                .init(input: Volume(2), style: .volume(.liters, style: .full).locale(locale), output: "2 liters")
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

private struct VolumeFormatStyleExpectation {
    let input: Volume
    let style: DecimalUnitFormatStyle<Volume>
    let output: String
}
