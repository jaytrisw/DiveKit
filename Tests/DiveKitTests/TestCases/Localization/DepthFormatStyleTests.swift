import Foundation
import Testing
@testable import DiveKit

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

    @Test func fullFormatStylePreservesSingularAndPluralUnits() async {
        await withTestLocalization(.test) {
            let locale = Locale.english
            let data: [DepthFormatStyleExpectation] = [
                .init(input: Depth(1), style: .depth(.feet, style: .full).locale(locale), output: "1 foot"),
                .init(input: Depth(2), style: .depth(.feet, style: .full).locale(locale), output: "2 feet"),
                .init(input: Depth(1), style: .depth(.meters, style: .full).locale(locale), output: "1 meter"),
                .init(input: Depth(2), style: .depth(.meters, style: .full).locale(locale), output: "2 meters")
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

private struct DepthFormatStyleExpectation {
    let input: Depth
    let style: DecimalUnitFormatStyle<Depth>
    let output: String
}
