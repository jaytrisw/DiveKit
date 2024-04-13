import XCTest
@testable import DiveKit

final class ErrorTestCase: SystemUnderTestCase<Error> {
    func testLocalizedDescriptionModuleBundle() {
        // Given
        sut = .negative(.depth(10), #function)

        // When
        let result = sut.localizedDescription

        // Then
        XCTAssertFalse(result.isEmpty)
    }

    func testLocalizedDescriptionMainBundle() {
        // Given
        let expectation = expectation(description: #function)
        sut = .negative(.depth(10), #function)

        Error.$mainBundle.withValue(.module) {
            // When
            let result = sut.localizedDescription

            // Then
            XCTAssertFalse(result.isEmpty)
            expectation.fulfill()
        }

        wait(for: [expectation])
    }
}
