import Foundation
import Testing
@testable import DiveKit

@Suite(.tags(.localization))
struct LocalizedStringTests {
    @Test func localizedStringFromMainBundle() {
        withTestLocalization(.test) {
            // Given
            let key: String.LocalizationValue = "test.localization.key"

            // When
            let result = localizedString(for: key)

            // Then
            #expect(result == "TEST LOCALIZED STRING")
        }
    }

    @Test func localizedStringWithQuantityFromMainBundle() {
        withTestLocalization(.test) {
            // Given
            let key: String.LocalizationValue = "test.localization.key.quantity"

            // When
            let result = localizedString(for: key, quantity: 1)

            // Then
            #expect(result == "1 TEST LOCALIZED STRING WITH QUANTITY")
        }
    }

    @Test func localizedQuantityStringReturnsOriginalStringWhenNumberIsMissing() {
        // Given
        let key: String.LocalizationValue = "test.localization.key.quantity"
        let localizedQuantity = "quantity unavailable"
        let resolver = LocalizationResolver { _, _, _ in
            localizedQuantity
        }

        // When
        let result = withTestLocalization(resolver) {
            localizedString(for: key, quantity: 1)
        }

        // Then
        #expect(result == localizedQuantity)
    }
}
