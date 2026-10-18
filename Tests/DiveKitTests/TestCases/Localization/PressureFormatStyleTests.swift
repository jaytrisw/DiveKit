import Foundation
import Testing
@testable import DiveKit
import DiveKitTestSupport

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

    @Test(arguments: [
        FormatStyleExpectation<Pressure>(input: Pressure(1), style: .pressure(.psi, style: .full).locale(.english), output: "1 pound per square inch"),
        FormatStyleExpectation<Pressure>(input: Pressure(2), style: .pressure(.psi, style: .full).locale(.english), output: "2 pounds per square inch"),
        FormatStyleExpectation<Pressure>(input: Pressure(1), style: .pressure(.atmospheres, style: .full).locale(.english), output: "1 atmosphere"),
        FormatStyleExpectation<Pressure>(input: Pressure(2), style: .pressure(.atmospheres, style: .full).locale(.english), output: "2 atmospheres")])
    func fullFormatStylePreservesSingularAndPluralUnits(expectation: FormatStyleExpectation<Pressure>) async {
        await withTestLocalization(.test) {
            await given {
                expectation
            } when: { expectation in
                expectation.input.formatted(expectation.style)
            } then: { expectation, result in
                #expect(result == expectation.output)
            }
        }
    }
}
