import Testing
@testable import DiveKit

@Suite
struct ErrorTests {
    @Test func localizedDescriptionModuleBundle() {
        withTestLocalization(.test) {
            // Given
            let sut = DiveKit.Error.negative(.depth(10), #function)

            // When
            let result = sut.localizedDescription

            // Then
            #expect(result == "Depth input must not be a negative value")
        }
    }
}
