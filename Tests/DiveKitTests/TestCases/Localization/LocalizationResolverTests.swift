import Foundation
import Testing
@testable import DiveKit

@Suite
struct LocalizationResolverTests {
    @Test func scopedResolverDoesNotMutateOuterResolver() {
        withTestLocalization(.test) {
            // Given
            let title = { Depth.Unit.feet.localizedTitle }
            let expectedString = UUID().uuidString
            let resolver = LocalizationResolver { _, _, _ in expectedString }

            // When
            let scopedTitle = Localization.standard.withResolver(resolver) {
                title()
            }

            // Then
            #expect(title() != expectedString)
            #expect(scopedTitle == expectedString)
        }
    }

    @Test func scopedResolversAreTaskLocal() async {
        await withTestLocalization(.test) {
            // Given
            let title: @Sendable () -> String = { Depth.Unit.feet.localizedTitle }
            let firstExpectedString = UUID().uuidString
            let secondExpectedString = UUID().uuidString
            let firstResolver = LocalizationResolver { _, _, _ in firstExpectedString }
            let secondResolver = LocalizationResolver { _, _, _ in secondExpectedString }

            // When
            async let firstTitle = Localization.standard.withResolver(firstResolver) { () async -> String in
                title()
            }
            async let secondTitle = Localization.standard.withResolver(secondResolver) { () async -> String in
                title()
            }

            let result = await (firstTitle, secondTitle)

            // Then
            #expect(title() != firstExpectedString)
            #expect(title() != secondExpectedString)
            #expect(result.0 == firstExpectedString)
            #expect(result.1 == secondExpectedString)
        }
    }

    @Test func scopedLocaleDoesNotMutateOuterLocale() {
        withTestLocalization(.test) {
            // Given
            let identifier = { Localization.standard.locale.identifier }
            let locale = Locale(identifier: "de_DE")

            // When
            let scopedIdentifier = Localization.standard.withLocale(locale) {
                identifier()
            }

            // Then
            #expect(scopedIdentifier == locale.identifier)
            #expect(identifier() == Locale.english.identifier)
        }
    }

    @Test func scopedLocalesAreTaskLocal() async {
        await withTestLocalization(.test) {
            // Given
            let identifier: @Sendable () -> String = { Localization.standard.locale.identifier }
            let first = Locale.english
            let second = Locale(identifier: "de_DE")

            // When
            async let firstLocale = Localization.standard.withLocale(
                first) { () async -> String in
                    identifier()
                }
            async let secondLocale = Localization.standard.withLocale(
                second) { () async -> String in
                    identifier()
                }

            let result = await (firstLocale, secondLocale)

            // Then
            #expect(result.0 == first.identifier)
            #expect(result.1 == second.identifier)
            #expect(identifier() == Locale.english.identifier)
        }
    }

    @Test func customResolverReceivesActiveLocale() {
        withTestLocalization(.test) {
            // Given
            let title = { Depth.Unit.feet.localizedTitle }
            let resolver = LocalizationResolver { _, _, locale in
                locale.identifier
            }
            let locale = Locale(identifier: "de_DE")

            // When
            let result = Localization.standard.withResolver(resolver) {
                Localization.standard.withLocale(locale) {
                    title()
                }
            }

            // Then
            #expect(result == locale.identifier)
        }
    }

    @Test func scopedResolverPreservesOuterScopedLocale() {
        withTestLocalization(.test) {
            // Given
            let title = { Depth.Unit.feet.localizedTitle }
            let resolver = LocalizationResolver { _, _, locale in
                locale.identifier
            }
            let locale = Locale(identifier: "de_DE")

            // When
            let result = Localization.standard.withLocale(locale) {
                Localization.standard.withResolver(resolver) {
                    title()
                }
            }

            // Then
            #expect(result == locale.identifier)
        }
    }

    @Test func setUpdatesSharedLocalizationConfiguration() {
        // Given
        let originalResolver = Localization.standard.resolver
        let originalLocale = Localization.standard.locale
        defer {
            Localization.standard.set(originalResolver)
            Localization.standard.set(originalLocale)
        }

        let resolverExpectedString = UUID().uuidString
        let resolver = LocalizationResolver { _, _, _ in resolverExpectedString }
        let locale = Locale(identifier: "de_DE")
        let closureExpectedString = UUID().uuidString

        // When
        Localization.standard.set(resolver)
        let resolverResult = Localization.standard.resolver.resolve("test", [], .english)

        Localization.standard.set(locale)
        let localeResult = Localization.standard.locale.identifier

        Localization.standard.set { _, _, _ in
            closureExpectedString
        }
        let closureResult = Localization.standard.resolver.resolve("test", [], .english)

        // Then
        #expect(resolverResult == resolverExpectedString)
        #expect(localeResult == locale.identifier)
        #expect(closureResult == closureExpectedString)
    }

    @Test func customResolverOverridesUnitTitle() {
        withTestLocalization(.test) {
            // Given
            let title = { Depth.Unit.feet.localizedTitle }
            let expectedString = UUID().uuidString
            let resolver = LocalizationResolver { _, _, _ in expectedString }

            // When
            let result = Localization.standard.withResolver(resolver) {
                title()
            }

            // Then
            #expect(title() != expectedString)
            #expect(result == expectedString)
        }
    }

    @Test func customResolverResolvesPluralQuantity() {
        withTestLocalization(.test) {
            // Given
            let resolver = LocalizationResolver.customDepthQuantity

            // When
            let result = Localization.standard.withResolver(resolver) {
                (
                    plural: Depth(33).formatted(.depth(.feet, style: .full)),
                    singular: Depth(1).formatted(.depth(.feet, style: .full)))
            }

            // Then
            #expect(result.plural == "33 custom feet")
            #expect(result.singular == "1 custom foot")
        }
    }

    @Test func catalogResolverMissingKeyResolvesToRawKey() {
        // Given
        let resolver = LocalizationResolver.catalog(named: "Missing", in: .module)

        // When
        let result = Localization.standard.withResolver(resolver) {
            Volume.Unit.liters.localizedTitle
        }

        // Then
        #expect(result == "dive.kit.unit.volume.title")
    }

    @Test func catalogResolverResolvesPluralQuantityFromStringsCatalog() {
        // Given
        let locale = Locale.english

        // When
        let result = Localization.standard.withResolver(.default) {
            (
                singular: Depth(1).formatted(.depth(.feet, style: .full).locale(locale)),
                plural: Depth(33).formatted(.depth(.feet, style: .full).locale(locale)))
        }

        // Then
        #expect(result.singular == "1 foot")
        #expect(result.plural == "33 feet")
    }

    @Test func defaultCatalogResolverResolvesUnitPluralQuantityFromStringsCatalog() {
        // Given
        let locale = Locale.english
        let sut = Depth.Unit.feet

        // When
        let result = Localization.standard.withResolver(.default) {
            Localization.standard.withLocale(locale) {
                (singular: sut.localization(for: .quantity(1, .full)), plural: sut.localization(for: .quantity(33, .full)))
            }
        }

        // Then
        #expect(result.singular == "1 foot")
        #expect(result.plural == "33 feet")
    }

    @Test func formatStyleLocaleIsPassedToResolver() {
        withTestLocalization(.test) {
            // Given
            let resolver = LocalizationResolver { _, arguments, locale in
                guard !arguments.isEmpty else {
                    return locale.identifier
                }

                return String(
                    format: "%.3f \(locale.identifier)",
                    locale: locale,
                    arguments: arguments)
            }
            let locale = Locale(identifier: "de_DE")

            // When
            let result = Localization.standard.withResolver(resolver) {
                Depth(1).formatted(.depth(.feet, style: .full).locale(locale))
            }

            // Then
            #expect(result == "1 \(locale.identifier)")
        }
    }

    @Test func rateQuantityUsesCustomResolverForBaseUnitLookup() {
        withTestLocalization(.test) {
            // Given
            let resolver = LocalizationResolver.customRateQuantity
            let sut = Rate<Depth>(1)

            // When
            let result = Localization.standard.withResolver(resolver) {
                sut.formatted(.rate(.perMinute(.feet), style: .full))
            }

            // Then
            #expect(result == "1 custom foot each minute")
        }
    }

    @Test func errorDescriptionUsesCustomResolver() {
        withTestLocalization(.test) {
            // Given
            let error = Error.negative(.depth(10), #function)
            let description = { error.localizedDescription }
            let expectedString = UUID().uuidString
            let resolver = LocalizationResolver { _, _, _ in expectedString }

            // When
            let result = Localization.standard.withResolver(resolver) {
                description()
            }

            // Then
            #expect(description() != expectedString)
            #expect(result == expectedString)
        }
    }

    @Test func decodedFormatStyleUsesActiveResolver() throws {
        // Given
        let style = DecimalUnitFormatStyle<Depth>(.feet, style: .full)
        let data = try JSONEncoder().encode(style)
        let decodedStyle = try JSONDecoder().decode(DecimalUnitFormatStyle<Depth>.self, from: data)

        // When
        let result = withTestLocalization(.test) {
            Localization.standard.withResolver(.customDepthQuantity) {
                Depth(1).formatted(decodedStyle)
            }
        }

        // Then
        #expect(result == "1 custom foot")
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
