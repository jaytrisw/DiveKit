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

        LocalizedKey.$mainBundle.withValue(.module) {
            // When
            let result = sut.localizedDescription

            // Then
            XCTAssertEqual(result, "TEST LOCALIZED STRING")
            expectation.fulfill()
        }

        wait(for: [expectation])
    }

    func testLocalizedDionMainBundle() {
        // Given
        let expectation = expectation(description: #function)

        LocalizedKey.$mainBundle.withValue(.module) {
            // When
            let result = localizedString(for: "test.pluralized", quantity: 0.0, with: .init(describing: self))

            // Then
            XCTAssertEqual(result, "0 values")
            expectation.fulfill()
        }

        wait(for: [expectation])
    }
}
