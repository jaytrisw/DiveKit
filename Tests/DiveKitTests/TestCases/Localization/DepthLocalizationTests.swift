import Testing
@testable import DiveKit

@Suite(.tags(.localization))
struct DepthLocalizationTests {
    @Test func localizedTitleDImperial() async {
        await withTestLocalization(.test) {
            await given {
                Depth.Unit.feet
            } when: { sut in
                sut.localizedTitle
            } then: { _, result in
                #expect(result == "Depth")
            }
        }
    }

    @Test func localizedTitleMetric() async {
        await withTestLocalization(.test) {
            await given {
                Depth.Unit.meters
            } when: { sut in
                sut.localizedTitle
            } then: { _, result in
                #expect(result == "Depth")
            }
        }
    }

    @Test func descriptionShortImperial() async {
        await withTestLocalization(.test) {
            await given {
                Depth.Unit.feet
            } when: { sut in
                sut.localizedDescription(for: .short)
            } then: { _, result in
                #expect(result == "ft")
            }
        }
    }

    @Test func descriptionShortMetric() async {
        await withTestLocalization(.test) {
            await given {
                Depth.Unit.meters
            } when: { sut in
                sut.localizedDescription(for: .short)
            } then: { _, result in
                #expect(result == "m")
            }
        }
    }

    @Test func descriptionFullImperial() async {
        await withTestLocalization(.test) {
            await given {
                Depth.Unit.feet
            } when: { sut in
                sut.localizedDescription(for: .full)
            } then: { _, result in
                #expect(result == "feet")
            }
        }
    }

    @Test func descriptionFullMetric() async {
        await withTestLocalization(.test) {
            await given {
                Depth.Unit.meters
            } when: { sut in
                sut.localizedDescription(for: .full)
            } then: { _, result in
                #expect(result == "meters")
            }
        }
    }

    @Test func quantityShortImperial() async {
        await withTestLocalization(.test) {
            await given {
                Depth.Unit.feet
            } when: { sut in
                sut.localization(for: .quantity(.zero, .short))
            } then: { _, result in
                #expect(result == "0 ft")
            }
        }
    }

    @Test func quantityShortMetric() async {
        await withTestLocalization(.test) {
            await given {
                Depth.Unit.meters
            } when: { sut in
                sut.localization(for: .quantity(.zero, .short))
            } then: { _, result in
                #expect(result == "0 m")
            }
        }
    }

    @Test func quantityFullImperial() async {
        await withTestLocalization(.test) {
            await given {
                Depth.Unit.feet
            } when: { sut in
                sut.localization(for: .quantity(.zero, .full))
            } then: { _, result in
                #expect(result == "0 feet")
            }
        }
    }

    @Test func quantityFullMetric() async {
        await withTestLocalization(.test) {
            await given {
                Depth.Unit.meters
            } when: { sut in
                sut.localization(for: .quantity(.zero, .full))
            } then: { _, result in
                #expect(result == "0 meters")
            }
        }
    }

    @Test func oneQuantityFullImperial() async {
        await withTestLocalization(.test) {
            await given {
                Depth.Unit.feet
            } when: { sut in
                sut.localization(for: .quantity(1, .full))
            } then: { _, result in
                #expect(result == "1 foot")
            }
        }
    }

    @Test func oneQuantityFullMetric() async {
        await withTestLocalization(.test) {
            await given {
                Depth.Unit.meters
            } when: { sut in
                sut.localization(for: .quantity(1, .full))
            } then: { _, result in
                #expect(result == "1 meter")
            }
        }
    }
}
