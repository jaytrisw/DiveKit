import Foundation
import Testing
@testable import DiveKit

@Suite(.tags(.localization, .rate))
struct RateFormatStyleTests {
    @Test func formatStyle() async {
        await withTestLocalization(.test) {
            await given {
                Rate<Pressure>(15)
            } when: { sut in
                sut.formatted(.rate(.perMinute(.psi), style: .full))
            } then: { _, result in
                #expect(result == "15 pounds per square inch per minute")
            }
        }
    }

    @Test func germanShortFormatStyleUsesExplicitPrecision() async {
        await withTestLocalization(.test) {
            await given {
                Rate<Depth>(33)
            } when: { sut in
                sut.formatted(
                .rate(.perMinute(.feet), style: .short)
                    .precision(.fractionLength(1))
                    .locale(Locale(identifier: "de_DE")))
            } then: { _, result in
                #expect(result == "33,0 ft/min")
            }
        }
    }

    @Test func germanMetricShortFormatStylePreservesMeaningfulDecimalDigit() async {
        await withTestLocalization(.test) {
            await given {
                Rate<Depth>(10.3)
            } when: { sut in
                sut.formatted(
                .rate(.perMinute(.meters), style: .short)
                    .precision(.fractionLength(1))
                    .locale(Locale(identifier: "de_DE")))
            } then: { _, result in
                #expect(result == "10,3 m/min")
            }
        }
    }

    @Test func englishShortFormatStyleUsesExplicitPrecision() async {
        await withTestLocalization(.test) {
            await given {
                Rate<Depth>(33)
            } when: { sut in
                sut.formatted(
                .rate(.perMinute(.feet), style: .short)
                    .precision(.fractionLength(1))
                    .locale(Locale.english))
            } then: { _, result in
                #expect(result == "33.0 ft/min")
            }
        }
    }

    @Test func fullFormatStylePreservesBaseUnitSingularAndPluralUnits() async {
        await withTestLocalization(.test) {
            await given {
                let locale = Locale.english

                return (
                    locale: locale,
                    singular: Rate<Pressure>(1),
                    plural: Rate<Pressure>(2))
            } when: { input in
                (
                    singular: input.singular.formatted(
                        .rate(.perMinute(.psi), style: .full).locale(input.locale)),
                    plural: input.plural.formatted(
                        .rate(.perMinute(.psi), style: .full).locale(input.locale)))
            } then: { _, result in
                #expect(result.singular == "1 pound per square inch per minute")
                #expect(result.plural == "2 pounds per square inch per minute")
            }
        }
    }
}
