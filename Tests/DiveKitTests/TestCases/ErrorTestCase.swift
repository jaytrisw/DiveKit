import Testing
@testable import DiveKit

final class ErrorTestCase: SystemUnderTestCase<Error> {
    @Test
    func testLocalizedDescriptionModuleBundle() {
        // Given
        sut = .negative(.depth(10), #function)

        // When
        let result = sut.localizedDescription

        // Then
        #expect(result == "Depth input must not be a negative value")
    }
}
