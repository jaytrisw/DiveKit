import Foundation
import Testing
@testable import DiveKit
import DiveKitTestSupport

@Suite(.tags(.localization))
struct DepthFormatStyleTests {
    @Test func formatStyle() async {
        await withTestLocalization(.test) {
            await given {
                Depth(15)
            } when: { sut in
                sut.formatted(.depth(.feet, style: .full))
            } then: { _, result in
                #expect(result == "15 feet")
            }
        }
    }

    @Test func germanShortFormatStyleUsesLocaleDecimalSeparator() async {
        await withTestLocalization(.test) {
            await given {
                Depth(33)
            } when: { sut in
                sut.formatted(.depth(.feet, style: .short).locale(Locale(identifier: "de_DE")))
            } then: { _, result in
                #expect(result == "33 ft")
                #expect(result != "33,000 ft")
            }
        }
    }

    @Test func germanShortFormatStyleUsesExplicitPrecision() async {
        await withTestLocalization(.test) {
            await given {
                Depth(33)
            } when: { sut in
                sut.formatted(
                .depth(.feet, style: .short)
                    .precision(.fractionLength(1))
                    .locale(Locale(identifier: "de_DE")))
            } then: { _, result in
                #expect(result == "33,0 ft")
            }
        }
    }

    @Test func germanMetricShortFormatStylePreservesMeaningfulDecimalDigit() async {
        await withTestLocalization(.test) {
            await given {
                Depth(10.3)
            } when: { sut in
                sut.formatted(
                .depth(.meters, style: .short)
                    .precision(.fractionLength(1))
                    .locale(Locale(identifier: "de_DE")))
            } then: { _, result in
                #expect(result == "10,3 m")
            }
        }
    }

    @Test func formatStyleUsesActiveLocaleWhenNoneIsSpecified() async {
        await withTestLocalization(.test, Locale(identifier: "de_DE")) {
            await given {
                Depth(10.3)
            } when: { sut in
                sut.formatted(.depth(.meters, style: .short))
            } then: { _, result in
                #expect(result == "10,3 m")
            }
        }
    }

    @Test func englishShortFormatStyleUsesExplicitPrecision() async {
        await withTestLocalization(.test) {
            await given {
                Depth(33)
            } when: { sut in
                sut.formatted(
                .depth(.feet, style: .short)
                    .precision(.fractionLength(1))
                    .locale(Locale.english))
            } then: { _, result in
                #expect(result == "33.0 ft")
            }
        }
    }

    @Test(arguments: [
        FormatStyleExpectation<Depth>(input: Depth(1), style: .depth(.feet, style: .full).locale(.english), output: "1 foot"),
        FormatStyleExpectation<Depth>(input: Depth(2), style: .depth(.feet, style: .full).locale(.english), output: "2 feet"),
        FormatStyleExpectation<Depth>(input: Depth(1), style: .depth(.meters, style: .full).locale(.english), output: "1 meter"),
        FormatStyleExpectation<Depth>(input: Depth(2), style: .depth(.meters, style: .full).locale(.english), output: "2 meters")])
    func fullFormatStylePreservesSingularAndPluralUnits(expectation: FormatStyleExpectation<Depth>) async {
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
