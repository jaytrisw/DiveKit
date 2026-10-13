import Foundation
import Testing
@testable import DiveKit

@Suite(.tags(.localization))
struct VolumeFormatStyleTests {
    @Test func formatStyle() async {
        await withTestLocalization(.test) {
            await given {
                Volume(15)
            } when: { sut in
                sut.formatted(.volume(.cubicFeet, style: .full))
            } then: { _, result in
                #expect(result == "15 cubic feet")
            }
        }
    }

    @Test func germanShortFormatStyleUsesExplicitPrecision() async {
        await withTestLocalization(.test) {
            await given {
                Volume(33)
            } when: { sut in
                sut.formatted(
                .volume(.cubicFeet, style: .short)
                    .precision(.fractionLength(1))
                    .locale(Locale(identifier: "de_DE")))
            } then: { _, result in
                #expect(result == "33,0 cu ft")
            }
        }
    }

    @Test func germanMetricShortFormatStylePreservesMeaningfulDecimalDigit() async {
        await withTestLocalization(.test) {
            await given {
                Volume(10.3)
            } when: { sut in
                sut.formatted(
                .volume(.liters, style: .short)
                    .precision(.fractionLength(1))
                    .locale(Locale(identifier: "de_DE")))
            } then: { _, result in
                #expect(result == "10,3 l")
            }
        }
    }

    @Test func englishShortFormatStyleUsesExplicitPrecision() async {
        await withTestLocalization(.test) {
            await given {
                Volume(33)
            } when: { sut in
                sut.formatted(
                .volume(.cubicFeet, style: .short)
                    .precision(.fractionLength(1))
                    .locale(Locale.english))
            } then: { _, result in
                #expect(result == "33.0 cu ft")
            }
        }
    }

    @Test func fullFormatStylePreservesSingularAndPluralUnits() async {
        await withTestLocalization(.test) {
            let locale = Locale.english
            let data: [VolumeFormatStyleExpectation] = [
                .init(input: Volume(1), style: .volume(.cubicFeet, style: .full).locale(locale), output: "1 cubic foot"),
                .init(input: Volume(2), style: .volume(.cubicFeet, style: .full).locale(locale), output: "2 cubic feet"),
                .init(input: Volume(1), style: .volume(.liters, style: .full).locale(locale), output: "1 liter"),
                .init(input: Volume(2), style: .volume(.liters, style: .full).locale(locale), output: "2 liters")
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

private struct VolumeFormatStyleExpectation {
    let input: Volume
    let style: DecimalUnitFormatStyle<Volume>
    let output: String
}
