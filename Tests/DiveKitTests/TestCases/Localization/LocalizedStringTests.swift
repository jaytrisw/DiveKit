import Foundation
import Testing
@testable import DiveKit

@Suite(.tags(.localization))
struct LocalizedStringTests {
    @Test func localizedStringFromMainBundle() async {
        await withTestLocalization(.test) {
            await given {
                let key: String.LocalizationValue = "test.localization.key"

                return key
            } when: { key in
                localizedString(for: key)
            } then: { _, result in
                #expect(result == "TEST LOCALIZED STRING")
            }
        }
    }

    @Test func localizedStringWithQuantityFromMainBundle() async {
        await withTestLocalization(.test) {
            await given {
                let key: String.LocalizationValue = "test.localization.key.quantity"

                return key
            } when: { key in
                localizedString(for: key, quantity: 1)
            } then: { _, result in
                #expect(result == "1 TEST LOCALIZED STRING WITH QUANTITY")
            }
        }
    }

    @Test func localizedQuantityStringReturnsOriginalStringWhenNumberIsMissing() async {
        await given {
            let key: String.LocalizationValue = "test.localization.key.quantity"
            let localizedQuantity = "quantity unavailable"
            let resolver = LocalizationResolver { _, _, _ in
                localizedQuantity
            }

            return (
                key: key,
                localizedQuantity: localizedQuantity,
                resolver: resolver)
        } when: { input in
            withTestLocalization(input.resolver) {
                localizedString(for: input.key, quantity: 1)
            }
        } then: { input, result in
            #expect(result == input.localizedQuantity)
        }
    }
}
