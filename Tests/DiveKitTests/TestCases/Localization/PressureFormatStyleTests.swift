import Foundation
import Testing
@testable import DiveKit

@Suite
struct PressureFormatStyleTests {
    @Test func formatStyle() {
        withTestLocalization(.test) {
            // Given
            let sut = Pressure(15)

            // When
            let result = sut.formatted(.pressure(.atmospheres, style: .full))

            // Then
            #expect(result == "15 atmospheres")
        }
    }

    @Test func germanShortFormatStyleUsesExplicitPrecision() {
        withTestLocalization(.test) {
            // Given
            let sut = Pressure(33)

            // When
            let result = sut.formatted(
                .pressure(.atmospheres, style: .short)
                    .precision(.fractionLength(1))
                    .locale(Locale(identifier: "de_DE")))

            // Then
            #expect(result == "33,0 atm")
        }
    }

    @Test func germanMetricShortFormatStylePreservesMeaningfulDecimalDigit() {
        withTestLocalization(.test) {
            // Given
            let sut = Pressure(10.3)

            // When
            let result = sut.formatted(
                .pressure(.bar, style: .short)
                    .precision(.fractionLength(1))
                    .locale(Locale(identifier: "de_DE")))

            // Then
            #expect(result == "10,3 bar")
        }
    }

    @Test func englishShortFormatStyleUsesExplicitPrecision() {
        withTestLocalization(.test) {
            // Given
            let sut = Pressure(33)

            // When
            let result = sut.formatted(
                .pressure(.atmospheres, style: .short)
                    .precision(.fractionLength(1))
                    .locale(Locale.english))

            // Then
            #expect(result == "33.0 atm")
        }
    }

    @Test func fullFormatStylePreservesSingularAndPluralUnits() {
        withTestLocalization(.test) {
            // Given
            let locale = Locale.english
            let data: [PressureFormatStyleExpectation] = [
                .init(input: Pressure(1), style: .pressure(.psi, style: .full).locale(locale), output: "1 pound per square inch"),
                .init(input: Pressure(2), style: .pressure(.psi, style: .full).locale(locale), output: "2 pounds per square inch"),
                .init(input: Pressure(1), style: .pressure(.atmospheres, style: .full).locale(locale), output: "1 atmosphere"),
                .init(input: Pressure(2), style: .pressure(.atmospheres, style: .full).locale(locale), output: "2 atmospheres")
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

private struct PressureFormatStyleExpectation {
    let input: Pressure
    let style: DecimalUnitFormatStyle<Pressure>
    let output: String
}
