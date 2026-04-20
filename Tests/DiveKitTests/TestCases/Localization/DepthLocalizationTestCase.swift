import Testing
@testable import DiveKit

@Suite("Depth Localization", .tags(.localization))
struct DepthLocalizationTestCase {
    @Test(arguments: [
        (unit: Depth.Unit.feet, title: "Depth"),
        (.meters, "Depth")
    ])
    func localizedTitle(unit: Depth.Unit, title: String) {
        #expect(unit.localizedTitle == title)
    }

    @Test(arguments: [
        (unit: Depth.Unit.feet, style: LocalizationStyle.short, description: "ft"),
        (.meters, .short, "m"),
        (.feet, .full, "feet"),
        (.meters, .full, "meters")
    ])
    func localizedDescription(unit: Depth.Unit, style: LocalizationStyle, description: String) {
        #expect(unit.localizedDescription(for: style) == description)
    }

    @Test(arguments: [
        (unit: Depth.Unit.feet, quantity: 0.0, style: LocalizationStyle.short, output: "0 ft"),
        (.meters, 0, .short, "0 m"),
        (.feet, 0, .full, "0 feet"),
        (.meters, 0, .full, "0 meters"),
        (.feet, 1, .full, "1 foot"),
        (.meters, 1, .full, "1 meter")
    ])
    func quantity(unit: Depth.Unit, quantity: Double, style: LocalizationStyle, output: String) {
        #expect(unit.localization(for: .quantity(quantity, style)) == output)
    }
}
