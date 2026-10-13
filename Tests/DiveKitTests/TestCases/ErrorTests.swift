import Testing
@testable import DiveKit

@Suite(.tags(.error, .localization))
struct ErrorTests {
    @Test func localizedDescriptionModuleBundle() async {
        await withTestLocalization(.test) {
            await given {
                DiveKit.Error.negative(.depth(10), #function)
            } when: { sut in
                sut.localizedDescription
            } then: { _, result in
                #expect(result == "Depth input must not be a negative value")
            }
        }
    }
}
