import Foundation
import Testing
@_spi(Experimental) @testable import DiveKit
import DiveKitTestSupport

#if os(macOS)
/// Checks the catalog and key sources in the checkout. These read files
/// through `#filePath`, which exist only where the package is built, so they
/// run on the host and not on a device.
@Suite("Localization catalog sources", .tags(.localization))
struct LocalizationCatalogSourceTests {
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
}

private extension LocalizationCatalogSourceTests {
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
#endif
