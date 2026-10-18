import Foundation
import Testing
@testable import DiveKit
import DiveKitTestSupport

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

    @Test(arguments: [
        FormatStyleExpectation<Mass>(input: Mass(1), style: .mass(.pounds, style: .full).locale(.english), output: "1 pound"),
        FormatStyleExpectation<Mass>(input: Mass(2), style: .mass(.pounds, style: .full).locale(.english), output: "2 pounds"),
        FormatStyleExpectation<Mass>(input: Mass(1), style: .mass(.kilograms, style: .full).locale(.english), output: "1 kilogram"),
        FormatStyleExpectation<Mass>(input: Mass(2), style: .mass(.kilograms, style: .full).locale(.english), output: "2 kilograms")])
    func fullFormatStylePreservesSingularAndPluralUnits(expectation: FormatStyleExpectation<Mass>) async {
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
