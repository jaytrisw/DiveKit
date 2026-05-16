import Testing
@testable import DiveKit

@Suite(.tags(.localization, .rate))
struct RateLocalizationTests {
    @Test func localizedTitle() async {
        await withTestLocalization(.test) {
            await given {
                Rate<Pressure>.Unit.perMinute(.psi)
            } when: { sut in
                sut.localizedTitle
            } then: { _, result in
                #expect(result == "Pressure Rate")
            }
        }
    }

    @Test func descriptionShort() async {
        await withTestLocalization(.test) {
            await given {
                Rate<Pressure>.Unit.perMinute(.psi)
            } when: { sut in
                sut.localizedDescription(for: .short)
            } then: { _, result in
                #expect(result == "psi/min")
            }
        }
    }

    @Test func descriptionFull() async {
        await withTestLocalization(.test) {
            await given {
                Rate<Volume>.Unit.perMinute(.cubicFeet)
            } when: { sut in
                sut.localizedDescription(for: .full)
            } then: { _, result in
                #expect(result == "cubic feet per minute")
            }
        }
    }

    @Test func quantityFull() async {
        await withTestLocalization(.test) {
            await given {
                Rate<Pressure>.Unit.perMinute(.psi)
            } when: { sut in
                sut.localization(for: .quantity(1, .full))
            } then: { _, result in
                #expect(result == "1 pound per square inch per minute")
            }
        }
    }
}
