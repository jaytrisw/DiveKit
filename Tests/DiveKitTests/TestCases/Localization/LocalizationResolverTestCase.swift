import XCTest
import Foundation
@testable import DiveKit

final class LocalizationResolverTestCase: XCTestCase {
    func testScopedResolverDoesNotMutateGlobalResolver() {
        let resolver = Localization.standard.resolver
        Localization.standard.set { _, _, _ in "Global" }
        defer { Localization.standard.set(resolver) }

        Localization.standard.withResolver(.init { _, _, _ in "Scoped" }) {
            XCTAssertEqual(Depth.Unit.feet.localizedTitle, "Scoped")
        }

        XCTAssertEqual(Depth.Unit.feet.localizedTitle, "Global")
    }

    func testScopedResolversAreTaskLocal() async {
        let firstResolver = LocalizationResolver { _, _, _ in
            "First"
        }
        let secondResolver = LocalizationResolver { _, _, _ in
            "Second"
        }

        async let firstTitle = Localization.standard.withResolver(firstResolver) { () async -> String in
            Depth.Unit.feet.localizedTitle
        }
        async let secondTitle = Localization.standard.withResolver(secondResolver) { () async -> String in
            Depth.Unit.feet.localizedTitle
        }

        let result = await (firstTitle, secondTitle)

        XCTAssertEqual(result.0, "First")
        XCTAssertEqual(result.1, "Second")
    }

    func testScopedLocaleDoesNotMutateGlobalLocale() {
        let locale = Localization.standard.locale
        Localization.standard.set(Locale(identifier: "en_US"))
        defer { Localization.standard.set(locale) }

        Localization.standard.withLocale(Locale(identifier: "de_DE")) {
            XCTAssertEqual(Localization.standard.locale.identifier, "de_DE")
        }

        XCTAssertEqual(Localization.standard.locale.identifier, "en_US")
    }

    func testScopedLocalesAreTaskLocal() async {
        async let firstLocale = Localization.standard.withLocale(
            Locale(identifier: "en_US")) { () async -> String in
                Localization.standard.locale.identifier
            }
        async let secondLocale = Localization.standard.withLocale(
            Locale(identifier: "de_DE")) { () async -> String in
                Localization.standard.locale.identifier
            }

        let result = await (firstLocale, secondLocale)

        XCTAssertEqual(result.0, "en_US")
        XCTAssertEqual(result.1, "de_DE")
    }

    func testCustomResolverReceivesActiveLocale() {
        let resolver = LocalizationResolver { _, _, locale in
            locale.identifier
        }

        Localization.standard.withResolver(resolver) {
            Localization.standard.withLocale(Locale(identifier: "de_DE")) {
                XCTAssertEqual(Depth.Unit.feet.localizedTitle, "de_DE")
            }
        }
    }

    func testScopedResolverPreservesOuterScopedLocale() {
        let resolver = LocalizationResolver { _, _, locale in
            locale.identifier
        }

        Localization.standard.withLocale(Locale(identifier: "de_DE")) {
            Localization.standard.withResolver(resolver) {
                XCTAssertEqual(Depth.Unit.feet.localizedTitle, "de_DE")
            }
        }
    }

    func testCustomResolverOverridesUnitTitle() {
        Localization.standard.withResolver(.init { _, _, _ in "Custom Depth" }) {
            XCTAssertEqual(Depth.Unit.feet.localizedTitle, "Custom Depth")
        }
    }

    func testCustomResolverResolvesPluralQuantity() {
        Localization.standard.withResolver(.customDepthQuantity) {
            XCTAssertEqual(Depth(33).formatted(.depth(.feet, style: .full)), "33 custom feet")
            XCTAssertEqual(Depth(1).formatted(.depth(.feet, style: .full)), "1 custom foot")
        }
    }

    func testCatalogResolverMissingKeyResolvesToRawKey() {
        Localization.standard.withResolver(.catalog(named: "Missing", in: .module)) {
            XCTAssertEqual(Volume.Unit.liters.localizedTitle, "dive.kit.unit.volume.title")
        }
    }

    func testCatalogResolverResolvesPluralQuantityFromStringsCatalog() throws {
        Localization.standard.withResolver(.default) {
            XCTAssertEqual(
                Depth(1).formatted(.depth(.feet, style: .full).locale(Locale(identifier: "en_US"))),
                "1 foot")
            XCTAssertEqual(
                Depth(33).formatted(.depth(.feet, style: .full).locale(Locale(identifier: "en_US"))),
                "33 feet")
        }
    }

    func testFormatStyleLocaleIsPassedToResolver() {
        let resolver = LocalizationResolver { _, arguments, locale in
            guard !arguments.isEmpty else {
                return locale.identifier
            }

            return String(
                format: "%.3f \(locale.identifier)",
                locale: locale,
                arguments: arguments)
        }

        Localization.standard.withResolver(resolver) {
            XCTAssertEqual(
                Depth(1).formatted(.depth(.feet, style: .full).locale(Locale(identifier: "de_DE"))),
                "1 de_DE")
        }
    }

    func testRateQuantityUsesCustomResolverForBaseUnitLookup() {
        Localization.standard.withResolver(.customRateQuantity) {
            let rate = Rate<Depth>(1)

            XCTAssertEqual(
                rate.formatted(.rate(.perMinute(.feet), style: .full)),
                "1 custom foot each minute")
        }
    }

    func testErrorDescriptionUsesCustomResolver() {
        Localization.standard.withResolver(.init { _, _, _ in "Custom depth error" }) {
            let error = Error.negative(.depth(10), #function)

            XCTAssertEqual(error.localizedDescription, "Custom depth error")
        }
    }

    func testDecodedFormatStyleUsesActiveResolver() throws {
        let style = DecimalUnitFormatStyle<Depth>(.feet, style: .full)
        let data = try JSONEncoder().encode(style)
        let decodedStyle = try JSONDecoder().decode(DecimalUnitFormatStyle<Depth>.self, from: data)

        Localization.standard.withResolver(.customDepthQuantity) {
            XCTAssertEqual(Depth(1).formatted(decodedStyle), "1 custom foot")
        }
    }
}

private extension LocalizationResolver {
    static let customDepthQuantity: Self = .init { _, arguments, locale in
        guard let quantity = arguments.first as? Double else {
            return ""
        }

        let format = quantity == 1 ? "%.3f custom foot" : "%.3f custom feet"

        return String(format: format, locale: locale, arguments: [quantity])
    }

    static let customRateQuantity: Self = .init { _, arguments, locale in
        guard let quantity = arguments.first as? Double else {
            return "%@ each minute"
        }

        let format = quantity == 1 ? "%.3f custom foot" : "%.3f custom feet"

        return String(format: format, locale: locale, arguments: [quantity])
    }
}
