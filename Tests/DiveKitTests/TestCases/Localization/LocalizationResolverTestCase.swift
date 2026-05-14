import XCTest
import Foundation
@testable import DiveKit

final class LocalizationResolverTestCase: XCTestCase {
    func testScopedResolverDoesNotMutateGlobalResolver() {
        let resolver = Localization.standard.resolver
        Localization.standard.set { _, _ in "Global" }
        defer { Localization.standard.set(resolver) }

        Localization.standard.withResolver(.init { _, _ in "Scoped" }) {
            XCTAssertEqual(Depth.Unit.feet.localizedTitle, "Scoped")
        }

        XCTAssertEqual(Depth.Unit.feet.localizedTitle, "Global")
    }

    func testScopedResolversAreTaskLocal() async {
        let firstResolver = LocalizationResolver { _, _ in
            "First"
        }
        let secondResolver = LocalizationResolver { _, _ in
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

    func testCustomResolverOverridesUnitTitle() {
        Localization.standard.withResolver(.init { _, _ in "Custom Depth" }) {
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
            XCTAssertEqual(Depth(1).formatted(.depth(.feet, style: .full)), "1 foot")
            XCTAssertEqual(Depth(33).formatted(.depth(.feet, style: .full)), "33 feet")
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
        Localization.standard.withResolver(.init { _, _ in "Custom depth error" }) {
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
    static let customDepthQuantity: Self = .init { _, arguments in
        guard let quantity = arguments.first as? Double else {
            return ""
        }

        let format = quantity == 1 ? "%.3f custom foot" : "%.3f custom feet"

        return String.localizedStringWithFormat(format, quantity)
    }

    static let customRateQuantity: Self = .init { _, arguments in
        guard let quantity = arguments.first as? Double else {
            return "%@ each minute"
        }

        let format = quantity == 1 ? "%.3f custom foot" : "%.3f custom feet"

        return String.localizedStringWithFormat(format, quantity)
    }
}
