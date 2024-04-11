import XCTest
@testable import DiveKit

final class ErrorTestCase: SystemUnderTestCase<Error> {
    func testLocalizedDescription() {
        // Given
        sut = .negative(.depth(10), #function)

        // When
        let result = sut.localizedDescription

        // Then
        XCTAssertNotNil(result)
    }
}
