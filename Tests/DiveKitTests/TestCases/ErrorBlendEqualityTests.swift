import Testing
@testable import DiveKit
import DiveKitTestSupport

@Suite("Error.Blend equality", .tags(.error, .blend))
struct ErrorBlendEqualityTests {
    // Each case paired with a different case carrying the same values, so only
    // the case differs.
    static let differentCases: [(DiveKit.Error.Blend, DiveKit.Error.Blend)] = [
        (.totalPressure(0.5, Blend<Unblended>()), .pressureRange(0.5, Blend<Unblended>())),
        (.pressureRange(0.5, Blend<Unblended>()), .totalPressure(0.5, Blend<Unblended>())),
        (.gasAlreadyPresent(Oxygen(), Blend<Unblended>()), .gasNotPresent(Oxygen(), Blend<Unblended>())),
        (.gasNotPresent(Oxygen(), Blend<Unblended>()), .gasAlreadyPresent(Oxygen(), Blend<Unblended>()))]

    @Test(arguments: differentCases)
    func differentCasesAreUnequal(lhs: DiveKit.Error.Blend, rhs: DiveKit.Error.Blend) async {
        await given {
            (lhs: lhs, rhs: rhs)
        } when: { input in
            input.lhs == input.rhs
        } then: { _, isEqual in
            #expect(!isEqual)
        }
    }
}
