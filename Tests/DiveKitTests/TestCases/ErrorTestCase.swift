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

        Error.$mainBundle.withValue(.init(for: Self.self)) {
            // When
            let result = sut.localizedDescription

            // Then
            XCTAssertNotEqual(result, "TEST LOCALIZED STRING")
            expectation.fulfill()
        }

        wait(for: [expectation])
    }
}
