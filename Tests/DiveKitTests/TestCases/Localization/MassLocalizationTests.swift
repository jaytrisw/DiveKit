import Testing
@testable import DiveKit

@Suite(.tags(.localization))
struct MassLocalizationTests {
    @Test func localizedTitleDImperial() async {
        await withTestLocalization(.test) {
            await given {
                Mass.Unit.pounds
            } when: { sut in
                sut.localizedTitle
            } then: { _, result in
                #expect(result == "Mass")
            }
        }
    }

    @Test func localizedTitleMetric() async {
        await withTestLocalization(.test) {
            await given {
                Mass.Unit.kilograms
            } when: { sut in
                sut.localizedTitle
            } then: { _, result in
                #expect(result == "Mass")
            }
        }
    }

    @Test func descriptionShortImperial() async {
        await withTestLocalization(.test) {
            await given {
                Mass.Unit.pounds
            } when: { sut in
                sut.localizedDescription(for: .short)
            } then: { _, result in
                #expect(result == "lbs")
            }
        }
    }

    @Test func descriptionShortMetric() async {
        await withTestLocalization(.test) {
            await given {
                Mass.Unit.kilograms
            } when: { sut in
                sut.localizedDescription(for: .short)
            } then: { _, result in
                #expect(result == "kg")
            }
        }
    }

    @Test func descriptionFullImperial() async {
        await withTestLocalization(.test) {
            await given {
                Mass.Unit.pounds
            } when: { sut in
                sut.localizedDescription(for: .full)
            } then: { _, result in
                #expect(result == "pounds")
            }
        }
    }

    @Test func descriptionFullMetric() async {
        await withTestLocalization(.test) {
            await given {
                Mass.Unit.kilograms
            } when: { sut in
                sut.localizedDescription(for: .full)
            } then: { _, result in
                #expect(result == "kilograms")
            }
        }
    }

    @Test func quantityShortImperial() async {
        await withTestLocalization(.test) {
            await given {
                Mass.Unit.pounds
            } when: { sut in
                sut.localization(for: .quantity(.zero, .short))
            } then: { _, result in
                #expect(result == "0 lbs")
            }
        }
    }

    @Test func quantityShortMetric() async {
        await withTestLocalization(.test) {
            await given {
                Mass.Unit.kilograms
            } when: { sut in
                sut.localization(for: .quantity(.zero, .short))
            } then: { _, result in
                #expect(result == "0 kg")
            }
        }
    }

    @Test func quantityFullImperial() async {
        await withTestLocalization(.test) {
            await given {
                Mass.Unit.pounds
            } when: { sut in
                sut.localization(for: .quantity(.zero, .full))
            } then: { _, result in
                #expect(result == "0 pounds")
            }
        }
    }

    @Test func quantityFullMetric() async {
        await withTestLocalization(.test) {
            await given {
                Mass.Unit.kilograms
            } when: { sut in
                sut.localization(for: .quantity(.zero, .full))
            } then: { _, result in
                #expect(result == "0 kilograms")
            }
        }
    }

    @Test func oneQuantityFullImperial() async {
        await withTestLocalization(.test) {
            await given {
                Mass.Unit.pounds
            } when: { sut in
                sut.localization(for: .quantity(1, .full))
            } then: { _, result in
                #expect(result == "1 pound")
            }
        }
    }

    @Test func oneQuantityFullMetric() async {
        await withTestLocalization(.test) {
            await given {
                Mass.Unit.kilograms
            } when: { sut in
                sut.localization(for: .quantity(1, .full))
            } then: { _, result in
                #expect(result == "1 kilogram")
            }
        }
    }
}
