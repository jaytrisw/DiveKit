import Testing
@testable import DiveKit

struct LocalizedStringTestCase {
    @Test
    func localizedStringFromMainBundle() {
        // Given
        let key = "test.localization.key"

        LocalizedKey.$mainBundle.withValue(.module) {
            // When
            let result = localizedString(for: key, with: .init())

            // Then
            #expect(result == "TEST LOCALIZED STRING")
        }
    }

    @Test
    func localizedStringWithQuantityFromMainBundle() {
        // Given
        let key = "test.localization.key.quantity"

        LocalizedKey.$mainBundle.withValue(.module) {
            // When
            let result = localizedString(for: key, quantity: 1, with: .init())

            // Then
            #expect(result == "1 TEST LOCALIZED STRING WITH QUANTITY")
        }
    }
}
