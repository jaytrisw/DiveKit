import XCTest
@testable import DiveKit

final class ErrorTestCase: SystemUnderTestCase<Error> {
    func testLocalizedDescriptionModuleBundle() {
        // Given
        sut = .negative(.depth(10), #function)

        // When
        let result = sut.localizedDescription

        // Then
        XCTAssertEqual(result, "Depth input must not be a negative value")
    }

    func testLocalizedDescriptionMainBundle() {
        // Given
        let expectation = expectation(description: #function)
        sut = .negative(.depth(10), #function)

        Error.$mainBundle.withValue(Bundle.module, operation: {
            // When
            let result = sut.localizedDescription

            // Then
            XCTAssertEqual(result, "TEST LOCALIZED STRING")
            expectation.fulfill()
        })

        wait(for: [expectation])
    }
}
