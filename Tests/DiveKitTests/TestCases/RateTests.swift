import Testing
@testable import DiveKit

@Suite(.tags(.rate))
struct RateTests {
    @Test func initialization() async {
        await given {
            15.0
        } when: { expected in
            Rate<Pressure>(expected)
        } then: { expected, sut in
            #expect(sut.value == expected)
        }
    }

    @Test func equatable() async {
        await given {
            (lhs: Rate<Pressure>(15), rhs: Rate<Pressure>(15))
        } when: { input in
            input.lhs == input.rhs
        } then: { _, result in
            #expect(result == true)
        }
    }

    @Test func localization() async {
        await withTestLocalization(.test) {
            await given {
                Rate<Pressure>(15)
            } when: { sut in
                sut.localization(for: .perMinute(.psi), style: .short)
            } then: { _, result in
                #expect(result == "15 psi/min")
            }
        }
    }
}
