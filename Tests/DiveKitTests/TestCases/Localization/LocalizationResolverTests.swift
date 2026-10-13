import Foundation
import Testing
@testable import DiveKit

@Suite(.tags(.localization))
struct LocalizationResolverTests {
    @Test func scopedResolverDoesNotMutateOuterResolver() async {
        await withTestLocalization(.test) {
            await given {
                let title = { Depth.Unit.feet.localizedTitle }
                let expectedString = UUID().uuidString
                let resolver = LocalizationResolver { _, _, _ in expectedString }

                return (title: title, expectedString: expectedString, resolver: resolver)
            } when: { input in
                Localization.standard.withResolver(input.resolver) {
                    input.title()
                }
            } then: { input, scopedTitle in
                #expect(input.title() != input.expectedString)
                #expect(scopedTitle == input.expectedString)
            }
        }
    }

    @Test func scopedResolversAreTaskLocal() async {
        await withTestLocalization(.test) {
            await given {
                let title: @Sendable () -> String = { Depth.Unit.feet.localizedTitle }
                let firstExpectedString = UUID().uuidString
                let secondExpectedString = UUID().uuidString
                let firstResolver = LocalizationResolver { _, _, _ in firstExpectedString }
                let secondResolver = LocalizationResolver { _, _, _ in secondExpectedString }

                return (
                    title: title,
                    firstExpectedString: firstExpectedString,
                    secondExpectedString: secondExpectedString,
                    firstResolver: firstResolver,
                    secondResolver: secondResolver)
            } when: { input in
                async let firstTitle = Localization.standard.withResolver(input.firstResolver) { () async -> String in
                    input.title()
                }
                async let secondTitle = Localization.standard.withResolver(input.secondResolver) { () async -> String in
                    input.title()
                }

                return await (firstTitle, secondTitle)
            } then: { input, result in
                #expect(input.title() != input.firstExpectedString)
                #expect(input.title() != input.secondExpectedString)
                #expect(result.0 == input.firstExpectedString)
                #expect(result.1 == input.secondExpectedString)
            }
        }
    }

    @Test func scopedLocaleDoesNotMutateOuterLocale() async {
        await withTestLocalization(.test) {
            await given {
                (
                    identifier: { Localization.standard.locale.identifier },
                    locale: Locale(identifier: "de_DE"))
            } when: { input in
                Localization.standard.withLocale(input.locale) {
                    input.identifier()
                }
            } then: { input, scopedIdentifier in
                #expect(scopedIdentifier == input.locale.identifier)
                #expect(input.identifier() == Locale.english.identifier)
            }
        }
    }

    @Test func scopedLocalesAreTaskLocal() async {
        await withTestLocalization(.test) {
            await given {
                let identifier: @Sendable () -> String = { Localization.standard.locale.identifier }

                return (
                    identifier: identifier,
                    first: Locale.english,
                    second: Locale(identifier: "de_DE"))
            } when: { input in
                async let firstLocale = Localization.standard.withLocale(
                    input.first) { () async -> String in
                        input.identifier()
                    }
                async let secondLocale = Localization.standard.withLocale(
                    input.second) { () async -> String in
                        input.identifier()
                    }

                return await (firstLocale, secondLocale)
            } then: { input, result in
                #expect(result.0 == input.first.identifier)
                #expect(result.1 == input.second.identifier)
                #expect(input.identifier() == Locale.english.identifier)
            }
        }
    }

    @Test func customResolverReceivesActiveLocale() async {
        await withTestLocalization(.test) {
            await given {
                let title = { Depth.Unit.feet.localizedTitle }
                let resolver = LocalizationResolver { _, _, locale in
                    locale.identifier
                }
                let locale = Locale(identifier: "de_DE")

                return (title: title, resolver: resolver, locale: locale)
            } when: { input in
                Localization.standard.withResolver(input.resolver) {
                    Localization.standard.withLocale(input.locale) {
                        input.title()
                    }
                }
            } then: { input, result in
                #expect(result == input.locale.identifier)
            }
        }
    }

    @Test func scopedResolverPreservesOuterScopedLocale() async {
        await withTestLocalization(.test) {
            await given {
                let title = { Depth.Unit.feet.localizedTitle }
                let resolver = LocalizationResolver { _, _, locale in
                    locale.identifier
                }
                let locale = Locale(identifier: "de_DE")

                return (title: title, resolver: resolver, locale: locale)
            } when: { input in
                Localization.standard.withLocale(input.locale) {
                    Localization.standard.withResolver(input.resolver) {
                        input.title()
                    }
                }
            } then: { input, result in
                #expect(result == input.locale.identifier)
            }
        }
    }

    @Test func setUpdatesSharedLocalizationConfiguration() async {
        await given {
            let originalResolver = Localization.standard.resolver
            let originalLocale = Localization.standard.locale
            let resolverExpectedString = UUID().uuidString
            let resolver = LocalizationResolver { _, _, _ in resolverExpectedString }
            let locale = Locale(identifier: "de_DE")
            let closureExpectedString = UUID().uuidString

            return (
                originalResolver: originalResolver,
                originalLocale: originalLocale,
                resolverExpectedString: resolverExpectedString,
                resolver: resolver,
                locale: locale,
                closureExpectedString: closureExpectedString)
        } when: { input in
            defer {
                Localization.standard.set(input.originalResolver)
                Localization.standard.set(input.originalLocale)
            }

            Localization.standard.set(input.resolver)
            let resolverResult = Localization.standard.resolver.resolve("test", [], .english)

            Localization.standard.set(input.locale)
            let localeResult = Localization.standard.locale.identifier

            Localization.standard.set { _, _, _ in
                input.closureExpectedString
            }
            let closureResult = Localization.standard.resolver.resolve("test", [], .english)

            return (
                resolver: resolverResult,
                locale: localeResult,
                closure: closureResult)
        } then: { input, result in
            #expect(result.resolver == input.resolverExpectedString)
            #expect(result.locale == input.locale.identifier)
            #expect(result.closure == input.closureExpectedString)
        }
    }

    @Test func customResolverOverridesUnitTitle() async {
        await withTestLocalization(.test) {
            await given {
                let title = { Depth.Unit.feet.localizedTitle }
                let expectedString = UUID().uuidString
                let resolver = LocalizationResolver { _, _, _ in expectedString }

                return (title: title, expectedString: expectedString, resolver: resolver)
            } when: { input in
                Localization.standard.withResolver(input.resolver) {
                    input.title()
                }
            } then: { input, result in
                #expect(input.title() != input.expectedString)
                #expect(result == input.expectedString)
            }
        }
    }

    @Test func customResolverResolvesPluralQuantity() async {
        await withTestLocalization(.test) {
            await given {
                LocalizationResolver.customDepthQuantity
            } when: { resolver in
                Localization.standard.withResolver(resolver) {
                    (
                        plural: Depth(33).formatted(.depth(.feet, style: .full)),
                        singular: Depth(1).formatted(.depth(.feet, style: .full)))
                }
            } then: { _, result in
                #expect(result.plural == "33 custom feet")
                #expect(result.singular == "1 custom foot")
            }
        }
    }

    @Test func catalogResolverMissingKeyResolvesToRawKey() async {
        await given {
            LocalizationResolver.catalog(named: "Missing", in: .module)
        } when: { resolver in
            Localization.standard.withResolver(resolver) {
                Volume.Unit.liters.localizedTitle
            }
        } then: { _, result in
            #expect(result == "dive.kit.unit.volume.title")
        }
    }

    @Test func formatStyleResolvesPluralQuantityWithActiveResolver() async {
        await given {
            Locale.english
        } when: { locale in
            withTestLocalization(.test, locale) {
                (
                    singular: Depth(1).formatted(.depth(.feet, style: .full).locale(locale)),
                    plural: Depth(33).formatted(.depth(.feet, style: .full).locale(locale)))
            }
        } then: { _, result in
            #expect(result.singular == "1 foot")
            #expect(result.plural == "33 feet")
        }
    }

    @Test func unitLocalizationResolvesPluralQuantityWithActiveResolver() async {
        await given {
            (locale: Locale.english, sut: Depth.Unit.feet)
        } when: { input in
            withTestLocalization(.test, input.locale) {
                (
                    singular: input.sut.localization(for: .quantity(1, .full)),
                    plural: input.sut.localization(for: .quantity(33, .full)))
            }
        } then: { _, result in
            #expect(result.singular == "1 foot")
            #expect(result.plural == "33 feet")
        }
    }

    @Test func formatStyleLocaleIsPassedToResolver() async {
        await withTestLocalization(.test) {
            await given {
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

                return (resolver: resolver, locale: locale)
            } when: { input in
                Localization.standard.withResolver(input.resolver) {
                    Depth(1).formatted(.depth(.feet, style: .full).locale(input.locale))
                }
            } then: { input, result in
                #expect(result == "1 \(input.locale.identifier)")
            }
        }
    }

    @Test func rateQuantityUsesCustomResolverForBaseUnitLookup() async {
        await withTestLocalization(.test) {
            await given {
                (resolver: LocalizationResolver.customRateQuantity, sut: Rate<Depth>(1))
            } when: { input in
                Localization.standard.withResolver(input.resolver) {
                    input.sut.formatted(.rate(.perMinute(.feet), style: .full))
                }
            } then: { _, result in
                #expect(result == "1 custom foot each minute")
            }
        }
    }

    @Test func errorDescriptionUsesCustomResolver() async {
        await withTestLocalization(.test) {
            await given {
                let error = Error.negative(.depth(10), #function)
                let description = { error.localizedDescription }
                let expectedString = UUID().uuidString
                let resolver = LocalizationResolver { _, _, _ in expectedString }

                return (description: description, expectedString: expectedString, resolver: resolver)
            } when: { input in
                Localization.standard.withResolver(input.resolver) {
                    input.description()
                }
            } then: { input, result in
                #expect(input.description() != input.expectedString)
                #expect(result == input.expectedString)
            }
        }
    }

    @Test func decodedFormatStyleUsesActiveResolver() async throws {
        try await given {
            let style = DecimalUnitFormatStyle<Depth>(.feet, style: .full)
            let data = try JSONEncoder().encode(style)

            return try JSONDecoder().decode(DecimalUnitFormatStyle<Depth>.self, from: data)
        } when: { decodedStyle in
            withTestLocalization(.test) {
                Localization.standard.withResolver(.customDepthQuantity) {
                    Depth(1).formatted(decodedStyle)
                }
            }
        } then: { _, result in
            #expect(result == "1 custom foot")
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
