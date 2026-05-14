import Foundation
import Testing
@testable import DiveKit

@Suite
struct LocalizedStringTests {
    @Test func localizedStringFromMainBundle() {
        withTestLocalization(.test) {
            // Given
            let key: String.LocalizationValue = "test.localization.key"

            // When
            let result = localizedString(for: key, with: .init())

            // Then
            #expect(result == "TEST LOCALIZED STRING")
        }
    }

    @Test func localizedStringWithQuantityFromMainBundle() {
        withTestLocalization(.test) {
            // Given
            let key: String.LocalizationValue = "test.localization.key.quantity"

            // When
            let result = localizedString(for: key, quantity: 1, with: .init())

            // Then
            #expect(result == "1 TEST LOCALIZED STRING WITH QUANTITY")
        }
    }
}
