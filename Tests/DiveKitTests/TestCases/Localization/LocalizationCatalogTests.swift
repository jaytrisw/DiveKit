import Foundation
import Testing
@_spi(Experimental) @testable import DiveKit
import DiveKitTestSupport

/// Resolves keys through ``LocalizationResolver/default``, which reads the
/// catalog DiveKit ships, rather than through the test catalog.
@Suite("Localization catalog", .tags(.localization))
struct LocalizationCatalogTests {
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
