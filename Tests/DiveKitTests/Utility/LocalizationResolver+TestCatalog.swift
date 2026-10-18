import Foundation
@testable import DiveKit

extension LocalizationResolver {
    /// Resolves DiveKit's keys from the catalog it ships, and the test bundle's
    /// own `test.localization.*` keys from the test catalog.
    static let test: Self = .init { key, arguments, locale in
        let shipped = LocalizationResolver.default.resolve(key, arguments, locale)
        guard shipped.hasPrefix("test.localization.") else {
            return shipped
        }

        return LocalizationResolver.catalog(in: .module).resolve(key, arguments, locale)
    }
}
