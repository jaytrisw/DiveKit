import Foundation
import Testing
@testable import DiveKit
import DiveKitTestSupport

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

    @Test(arguments: [
        FormatStyleExpectation<Volume>(input: Volume(1), style: .volume(.cubicFeet, style: .full).locale(.english), output: "1 cubic foot"),
        FormatStyleExpectation<Volume>(input: Volume(2), style: .volume(.cubicFeet, style: .full).locale(.english), output: "2 cubic feet"),
        FormatStyleExpectation<Volume>(input: Volume(1), style: .volume(.liters, style: .full).locale(.english), output: "1 liter"),
        FormatStyleExpectation<Volume>(input: Volume(2), style: .volume(.liters, style: .full).locale(.english), output: "2 liters")])
    func fullFormatStylePreservesSingularAndPluralUnits(expectation: FormatStyleExpectation<Volume>) async {
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
