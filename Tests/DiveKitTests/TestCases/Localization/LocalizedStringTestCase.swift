import XCTest
@testable import DiveKit

final class LocalizedStringTestCase: XCTestCase {
    func testLocalizedStringFromMainBundle() {
        // Given
        let expectation = expectation(description: #function)
        let key = "test.localization.key"

        LocalizedKey.$mainBundle.withValue(.module) {
            // When
            let result = localizedString(for: key, with: .init())

            // Then
            XCTAssertEqual(result, "TEST LOCALIZED STRING")
            expectation.fulfill()
        }

        wait(for: [expectation])
    }

    func testLocalizedStringWithQuantityFromMainBundle() {
        // Given
        let expectation = expectation(description: #function)
        let key = "test.localization.key.quantity"

        LocalizedKey.$mainBundle.withValue(.module) {
            // When
            let result = localizedString(for: key, quantity: 1, with: .init())

            // Then
            XCTAssertEqual(result, "1 TEST LOCALIZED STRING WITH QUANTITY")
            expectation.fulfill()
        }

        wait(for: [expectation])
    }
}
