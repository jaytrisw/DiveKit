import Testing
@testable import DiveKit

@Suite("Mass Localization", .tags(.localization))
struct MassLocalizationTestCase {
    @Test(arguments: [
        (unit: Mass.Unit.pounds, title: "Mass"),
        (.kilograms, "Mass")
    ])
    func localizedTitle(unit: Mass.Unit, title: String) {
        #expect(unit.localizedTitle == title)
    }

    @Test(arguments: [
        (unit: Mass.Unit.pounds, style: LocalizationStyle.short, description: "lbs"),
        (.kilograms, .short, "kg"),
        (.pounds, .full, "pounds"),
        (.kilograms, .full, "kilograms")
    ])
    func localizedDescription(unit: Mass.Unit, style: LocalizationStyle, description: String) {
        #expect(unit.localizedDescription(for: style) == description)
    }

    @Test(arguments: [
        (unit: Mass.Unit.pounds, quantity: 0.0, style: LocalizationStyle.short, output: "0 lbs"),
        (.kilograms, 0, .short, "0 kg"),
        (.pounds, 0, .full, "0 pounds"),
        (.kilograms, 0, .full, "0 kilograms"),
        (.pounds, 1, .full, "1 pound"),
        (.kilograms, 1, .full, "1 kilogram")
    ])
    func quantity(unit: Mass.Unit, quantity: Double, style: LocalizationStyle, output: String) {
        #expect(unit.localization(for: .quantity(quantity, style)) == output)
    }
}
