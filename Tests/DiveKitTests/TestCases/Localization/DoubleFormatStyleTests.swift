import Testing
@testable import DiveKit

@Suite(.tags(.localization))
struct DoubleFormatStyleTests {
    @Test func formatStyleDepth() async {
        await withTestLocalization(.test) {
            await given {
                15
            } when: { sut in
                sut.formatted(.depth(.feet, style: .full))
            } then: { _, result in
                #expect(result == "15 feet")
            }
        }
    }

    @Test func formatStyleMass() async {
        await withTestLocalization(.test) {
            await given {
                15
            } when: { sut in
                sut.formatted(.mass(.pounds, style: .full))
            } then: { _, result in
                #expect(result == "15 pounds")
            }
        }
    }

    @Test func formatStylePressure() async {
        await withTestLocalization(.test) {
            await given {
                15
            } when: { sut in
                sut.formatted(.pressure(.atmospheres, style: .full))
            } then: { _, result in
                #expect(result == "15 atmospheres")
            }
        }
    }

    @Test func formatStyleVolume() async {
        await withTestLocalization(.test) {
            await given {
                15
            } when: { sut in
                sut.formatted(.volume(.cubicFeet, style: .full))
            } then: { _, result in
                #expect(result == "15 cubic feet")
            }
        }
    }
}
