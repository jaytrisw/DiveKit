import Foundation
import Testing
@_spi(Experimental) @testable import DiveKit
import DiveKitTestSupport

/// Resolves keys through ``LocalizationResolver/default``, which reads the
/// catalog DiveKit ships, rather than through the test catalog.
@Suite("Localization catalog", .tags(.localization))
struct LocalizationCatalogTests {
    static let shippingKeys: [String] = Self.catalogKeys()

    @Test
    func everyLocalizedKeyIsInTheShippingCatalog() async throws {
        try await given {
            try Self.localizedKeyLiterals()
        } when: { literals in
            literals.filter { !Self.shippingKeys.contains($0) }
        } then: { literals, missing in
            #expect(!literals.isEmpty)
            #expect(missing.isEmpty, "Missing from Localizable.xcstrings: \(missing)")
        }
    }

    @Test(arguments: shippingKeys)
    func shippingKeyResolves(key: String) async {
        await given {
            key
        } when: { key in
            LocalizationResolver.default.resolve(.init(key), [], .english)
        } then: { key, result in
            #expect(result != key)
            #expect(!result.isEmpty)
        }
    }

    @Test(arguments: [
        (Depth(1), Depth.Unit.feet, "1 foot"),
        (Depth(2), .feet, "2 feet"),
        (Depth(1), .meters, "1 meter"),
        (Depth(2), .meters, "2 meters")])
    func quantityKeysPluralize(depth: Depth, unit: Depth.Unit, expected: String) async {
        await given {
            depth
        } when: { depth in
            withTestLocalization(.default) {
                depth.formatted(.depth(unit, style: .full).locale(.english))
            }
        } then: { _, result in
            #expect(result == expected)
        }
    }

    @Test
    func errorDescriptionResolvesFromShippingCatalog() async {
        await given {
            Error.negative(Depth(-1), "Test.call()")
        } when: { error in
            withTestLocalization(.default) {
                error.localizedDescription
            }
        } then: { _, result in
            #expect(result == "Depth input must not be a negative value")
        }
    }
}

private extension LocalizationCatalogTests {
    static var sourcesURL: URL {
        URL(fileURLWithPath: #filePath)
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .appendingPathComponent("Sources/DiveKitLocalization", isDirectory: true)
    }

    static func catalogKeys() -> [String] {
        let url = sourcesURL.appendingPathComponent("Resources/Localizable.xcstrings")
        guard let data = try? Data(contentsOf: url),
              let catalog = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let strings = catalog["strings"] as? [String: Any] else {
            return []
        }
        return strings.keys.sorted()
    }

    static func localizedKeyLiterals() throws -> [String] {
        let url = sourcesURL.appendingPathComponent("Internal/Localization/LocalizedKey.swift")
        let source = try String(contentsOf: url, encoding: .utf8)
        let regex = try NSRegularExpression(pattern: #""(dive\.kit\.[a-z.]+)""#)
        return regex
            .matches(in: source, range: NSRange(source.startIndex..., in: source))
            .compactMap { Range($0.range(at: 1), in: source).map { String(source[$0]) } }
    }
}
