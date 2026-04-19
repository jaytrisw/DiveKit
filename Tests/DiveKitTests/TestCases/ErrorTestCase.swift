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
        expectEqual(result, "Depth input must not be a negative value")
    }
}
