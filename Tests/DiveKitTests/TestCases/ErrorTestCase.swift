import Testing
@testable import DiveKit

@Suite("Error", .tags(.error))
struct ErrorTestCase {
    @Test
    func localizedDescriptionUsesModuleBundle() {
        let sut = Error.negative(.depth(10), #function)

        let result = sut.localizedDescription

        #expect(result == "Depth input must not be a negative value")
    }
}
