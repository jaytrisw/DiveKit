import Testing
@testable import DiveKit

@Suite(.tags(.localization))
struct VolumeLocalizationTests {
    @Test func localizedTitleDImperial() async {
        await withTestLocalization(.test) {
            await given {
                Volume.Unit.cubicFeet
            } when: { sut in
                sut.localizedTitle
            } then: { _, result in
                #expect(result == "Volume")
            }
        }
    }

    @Test func localizedTitleMetric() async {
        await withTestLocalization(.test) {
            await given {
                Volume.Unit.liters
            } when: { sut in
                sut.localizedTitle
            } then: { _, result in
                #expect(result == "Volume")
            }
        }
    }

    @Test func descriptionShortImperial() async {
        await withTestLocalization(.test) {
            await given {
                Volume.Unit.cubicFeet
            } when: { sut in
                sut.localizedDescription(for: .short)
            } then: { _, result in
                #expect(result == "cu ft")
            }
        }
    }

    @Test func descriptionShortMetric() async {
        await withTestLocalization(.test) {
            await given {
                Volume.Unit.liters
            } when: { sut in
                sut.localizedDescription(for: .short)
            } then: { _, result in
                #expect(result == "l")
            }
        }
    }

    @Test func descriptionFullImperial() async {
        await withTestLocalization(.test) {
            await given {
                Volume.Unit.cubicFeet
            } when: { sut in
                sut.localizedDescription(for: .full)
            } then: { _, result in
                #expect(result == "cubic feet")
            }
        }
    }

    @Test func descriptionFullMetric() async {
        await withTestLocalization(.test) {
            await given {
                Volume.Unit.liters
            } when: { sut in
                sut.localizedDescription(for: .full)
            } then: { _, result in
                #expect(result == "liters")
            }
        }
    }

    @Test func quantityShortImperial() async {
        await withTestLocalization(.test) {
            await given {
                Volume.Unit.cubicFeet
            } when: { sut in
                sut.localization(for: .quantity(.zero, .short))
            } then: { _, result in
                #expect(result == "0 cu ft")
            }
        }
    }

    @Test func quantityShortMetric() async {
        await withTestLocalization(.test) {
            await given {
                Volume.Unit.liters
            } when: { sut in
                sut.localization(for: .quantity(.zero, .short))
            } then: { _, result in
                #expect(result == "0 l")
            }
        }
    }

    @Test func quantityFullImperial() async {
        await withTestLocalization(.test) {
            await given {
                Volume.Unit.cubicFeet
            } when: { sut in
                sut.localization(for: .quantity(.zero, .full))
            } then: { _, result in
                #expect(result == "0 cubic feet")
            }
        }
    }

    @Test func quantityFullMetric() async {
        await withTestLocalization(.test) {
            await given {
                Volume.Unit.liters
            } when: { sut in
                sut.localization(for: .quantity(.zero, .full))
            } then: { _, result in
                #expect(result == "0 liters")
            }
        }
    }

    @Test func oneQuantityFullImperial() async {
        await withTestLocalization(.test) {
            await given {
                Volume.Unit.cubicFeet
            } when: { sut in
                sut.localization(for: .quantity(1, .full))
            } then: { _, result in
                #expect(result == "1 cubic foot")
            }
        }
    }

    @Test func oneQuantityFullMetric() async {
        await withTestLocalization(.test) {
            await given {
                Volume.Unit.liters
            } when: { sut in
                sut.localization(for: .quantity(1, .full))
            } then: { _, result in
                #expect(result == "1 liter")
            }
        }
    }
}
