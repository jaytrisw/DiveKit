import Foundation
import Testing
@testable import DiveKit

@Suite(.tags(.localization))
struct PressureFormatStyleTests {
    @Test func formatStyle() async {
        await withTestLocalization(.test) {
            await given {
                Pressure(15)
            } when: { sut in
                sut.formatted(.pressure(.atmospheres, style: .full))
            } then: { _, result in
                #expect(result == "15 atmospheres")
            }
        }
    }

    @Test func germanShortFormatStyleUsesExplicitPrecision() async {
        await withTestLocalization(.test) {
            await given {
                Pressure(33)
            } when: { sut in
                sut.formatted(
                .pressure(.atmospheres, style: .short)
                    .precision(.fractionLength(1))
                    .locale(Locale(identifier: "de_DE")))
            } then: { _, result in
                #expect(result == "33,0 atm")
            }
        }
    }

    @Test func germanMetricShortFormatStylePreservesMeaningfulDecimalDigit() async {
        await withTestLocalization(.test) {
            await given {
                Pressure(10.3)
            } when: { sut in
                sut.formatted(
                .pressure(.bar, style: .short)
                    .precision(.fractionLength(1))
                    .locale(Locale(identifier: "de_DE")))
            } then: { _, result in
                #expect(result == "10,3 bar")
            }
        }
    }

    @Test func englishShortFormatStyleUsesExplicitPrecision() async {
        await withTestLocalization(.test) {
            await given {
                Pressure(33)
            } when: { sut in
                sut.formatted(
                .pressure(.atmospheres, style: .short)
                    .precision(.fractionLength(1))
                    .locale(Locale.english))
            } then: { _, result in
                #expect(result == "33.0 atm")
            }
        }
    }

    @Test func fullFormatStylePreservesSingularAndPluralUnits() async {
        await withTestLocalization(.test) {
            let locale = Locale.english
            let data: [PressureFormatStyleExpectation] = [
                .init(input: Pressure(1), style: .pressure(.psi, style: .full).locale(locale), output: "1 pound per square inch"),
                .init(input: Pressure(2), style: .pressure(.psi, style: .full).locale(locale), output: "2 pounds per square inch"),
                .init(input: Pressure(1), style: .pressure(.atmospheres, style: .full).locale(locale), output: "1 atmosphere"),
                .init(input: Pressure(2), style: .pressure(.atmospheres, style: .full).locale(locale), output: "2 atmospheres")
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

private struct PressureFormatStyleExpectation {
    let input: Pressure
    let style: DecimalUnitFormatStyle<Pressure>
    let output: String
}
