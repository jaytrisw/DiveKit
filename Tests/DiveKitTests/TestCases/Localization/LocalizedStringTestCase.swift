import XCTest
import Foundation
@testable import DiveKit

final class LocalizedStringTestCase: XCTestCase {
    func testLocalizedStringFromMainBundle() {
        // Given
        let key: String.LocalizationValue = "test.localization.key"

        Localization.standard.withResolver(.diveKitTestCatalog) {
            // When
            let result = localizedString(for: key, with: .init())

            // Then
            XCTAssertEqual(result, "TEST LOCALIZED STRING")
        }
    }

    func testLocalizedStringWithQuantityFromMainBundle() {
        // Given
        let key: String.LocalizationValue = "test.localization.key.quantity"

        Localization.standard.withResolver(.diveKitTestCatalog) {
            // When
            let result = localizedString(for: key, quantity: 1, with: .init())

            // Then
            XCTAssertEqual(result, "1 TEST LOCALIZED STRING WITH QUANTITY")
        }
    }
}
