import Foundation
@testable import DiveKit

func withTestLocalization<Result>(
    _ resolver: LocalizationResolver = .test,
    _ locale: Locale = .english,
    _ operation: () throws -> Result) rethrows -> Result {
    try Localization.standard.withResolver(resolver) {
        try Localization.standard.withLocale(locale) {
            try operation()
        }
    }
}

func withTestLocalization<Result>(
    _ resolver: LocalizationResolver = .test,
    _ locale: Locale = .english,
    _ operation: () async throws -> Result) async rethrows -> Result {
    try await Localization.standard.withResolver(resolver) {
        try await Localization.standard.withLocale(locale) {
            try await operation()
        }
    }
}

extension Locale {
    static var english: Locale {
        .init(identifier: "en_US")
    }
}
