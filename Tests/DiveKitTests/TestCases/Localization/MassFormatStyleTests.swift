import Foundation
import Testing
@testable import DiveKit

@Suite(.tags(.localization))
struct MassFormatStyleTests {
    @Test func formatStyle() async {
        await withTestLocalization(.test) {
            await given {
                Mass(15)
            } when: { sut in
                sut.formatted(.mass(.pounds, style: .full))
            } then: { _, result in
                #expect(result == "15 pounds")
            }
        }
    }

    @Test func germanShortFormatStyleUsesExplicitPrecision() async {
        await withTestLocalization(.test) {
            await given {
                Mass(33)
            } when: { sut in
                sut.formatted(
                .mass(.pounds, style: .short)
                    .precision(.fractionLength(1))
                    .locale(Locale(identifier: "de_DE")))
            } then: { _, result in
                #expect(result == "33,0 lbs")
            }
        }
    }

    @Test func germanMetricShortFormatStylePreservesMeaningfulDecimalDigit() async {
        await withTestLocalization(.test) {
            await given {
                Mass(10.3)
            } when: { sut in
                sut.formatted(
                .mass(.kilograms, style: .short)
                    .precision(.fractionLength(1))
                    .locale(Locale(identifier: "de_DE")))
            } then: { _, result in
                #expect(result == "10,3 kg")
            }
        }
    }

    @Test func englishShortFormatStyleUsesExplicitPrecision() async {
        await withTestLocalization(.test) {
            await given {
                Mass(33)
            } when: { sut in
                sut.formatted(
                .mass(.pounds, style: .short)
                    .precision(.fractionLength(1))
                    .locale(Locale.english))
            } then: { _, result in
                #expect(result == "33.0 lbs")
            }
        }
    }

    @Test func fullFormatStylePreservesSingularAndPluralUnits() async {
        await withTestLocalization(.test) {
            let locale = Locale.english
            let data: [MassFormatStyleExpectation] = [
                .init(input: Mass(1), style: .mass(.pounds, style: .full).locale(locale), output: "1 pound"),
                .init(input: Mass(2), style: .mass(.pounds, style: .full).locale(locale), output: "2 pounds"),
                .init(input: Mass(1), style: .mass(.kilograms, style: .full).locale(locale), output: "1 kilogram"),
                .init(input: Mass(2), style: .mass(.kilograms, style: .full).locale(locale), output: "2 kilograms")
            ]

            for datum in data {
                await given {
                    datum
                } when: { datum in
                    datum.input.formatted(datum.style)
                } then: { datum, result in
                    #expect(result == datum.output)
                }
            }
        }
    }
}

private struct MassFormatStyleExpectation {
    let input: Mass
    let style: DecimalUnitFormatStyle<Mass>
    let output: String
}
