import Testing
@testable import DiveKit

@Suite(.tags(.localization))
struct PressureLocalizationTests {
    @Test func localizedTitleDImperial() async {
        await withTestLocalization(.test) {
            await given {
                Pressure.Unit.psi
            } when: { sut in
                sut.localizedTitle
            } then: { _, result in
                #expect(result == "Pressure")
            }
        }
    }

    @Test func localizedTitleMetric() async {
        await withTestLocalization(.test) {
            await given {
                Pressure.Unit.bar
            } when: { sut in
                sut.localizedTitle
            } then: { _, result in
                #expect(result == "Pressure")
            }
        }
    }

    @Test func localizedTitleAtmospheres() async {
        await withTestLocalization(.test) {
            await given {
                Pressure.Unit.atmospheres
            } when: { sut in
                sut.localizedTitle
            } then: { _, result in
                #expect(result == "Pressure")
            }
        }
    }

    @Test func descriptionShortImperial() async {
        await withTestLocalization(.test) {
            await given {
                Pressure.Unit.psi
            } when: { sut in
                sut.localizedDescription(for: .short)
            } then: { _, result in
                #expect(result == "psi")
            }
        }
    }

    @Test func descriptionShortMetric() async {
        await withTestLocalization(.test) {
            await given {
                Pressure.Unit.bar
            } when: { sut in
                sut.localizedDescription(for: .short)
            } then: { _, result in
                #expect(result == "bar")
            }
        }
    }

    @Test func descriptionShortAtmospheres() async {
        await withTestLocalization(.test) {
            await given {
                Pressure.Unit.atmospheres
            } when: { sut in
                sut.localizedDescription(for: .short)
            } then: { _, result in
                #expect(result == "atm")
            }
        }
    }

    @Test func descriptionFullImperial() async {
        await withTestLocalization(.test) {
            await given {
                Pressure.Unit.psi
            } when: { sut in
                sut.localizedDescription(for: .full)
            } then: { _, result in
                #expect(result == "pounds per square inch")
            }
        }
    }

    @Test func descriptionFullMetric() async {
        await withTestLocalization(.test) {
            await given {
                Pressure.Unit.bar
            } when: { sut in
                sut.localizedDescription(for: .full)
            } then: { _, result in
                #expect(result == "bar")
            }
        }
    }

    @Test func descriptionFullAtmospheres() async {
        await withTestLocalization(.test) {
            await given {
                Pressure.Unit.atmospheres
            } when: { sut in
                sut.localizedDescription(for: .full)
            } then: { _, result in
                #expect(result == "atmospheres")
            }
        }
    }

    @Test func quantityShortImperial() async {
        await withTestLocalization(.test) {
            await given {
                Pressure.Unit.psi
            } when: { sut in
                sut.localization(for: .quantity(.zero, .short))
            } then: { _, result in
                #expect(result == "0 psi")
            }
        }
    }

    @Test func quantityShortMetric() async {
        await withTestLocalization(.test) {
            await given {
                Pressure.Unit.bar
            } when: { sut in
                sut.localization(for: .quantity(.zero, .short))
            } then: { _, result in
                #expect(result == "0 bar")
            }
        }
    }

    @Test func quantityShortAtmospheres() async {
        await withTestLocalization(.test) {
            await given {
                Pressure.Unit.atmospheres
            } when: { sut in
                sut.localization(for: .quantity(.zero, .short))
            } then: { _, result in
                #expect(result == "0 atm")
            }
        }
    }

    @Test func quantityFullImperial() async {
        await withTestLocalization(.test) {
            await given {
                Pressure.Unit.psi
            } when: { sut in
                sut.localization(for: .quantity(.zero, .full))
            } then: { _, result in
                #expect(result == "0 pounds per square inch")
            }
        }
    }

    @Test func quantityFullMetric() async {
        await withTestLocalization(.test) {
            await given {
                Pressure.Unit.bar
            } when: { sut in
                sut.localization(for: .quantity(.zero, .full))
            } then: { _, result in
                #expect(result == "0 bar")
            }
        }
    }

    @Test func quantityFullAtmospheres() async {
        await withTestLocalization(.test) {
            await given {
                Pressure.Unit.atmospheres
            } when: { sut in
                sut.localization(for: .quantity(.zero, .full))
            } then: { _, result in
                #expect(result == "0 atmospheres")
            }
        }
    }

    @Test func oneQuantityFullImperial() async {
        await withTestLocalization(.test) {
            await given {
                Pressure.Unit.psi
            } when: { sut in
                sut.localization(for: .quantity(1, .full))
            } then: { _, result in
                #expect(result == "1 pound per square inch")
            }
        }
    }

    @Test func oneQuantityFullMetric() async {
        await withTestLocalization(.test) {
            await given {
                Pressure.Unit.bar
            } when: { sut in
                sut.localization(for: .quantity(1, .full))
            } then: { _, result in
                #expect(result == "1 bar")
            }
        }
    }

    @Test func oneQuantityFullAtmospheres() async {
        await withTestLocalization(.test) {
            await given {
                Pressure.Unit.atmospheres
            } when: { sut in
                sut.localization(for: .quantity(1, .full))
            } then: { _, result in
                #expect(result == "1 atmosphere")
            }
        }
    }
}
