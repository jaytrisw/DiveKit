import Testing
@testable import DiveKit

@Suite("Volume Localization", .tags(.localization))
struct VolumeLocalizationTestCase {
    @Test(arguments: [
        (unit: Volume.Unit.cubicFeet, title: "Volume"),
        (.liters, "Volume")
    ])
    func localizedTitle(unit: Volume.Unit, title: String) {
        #expect(unit.localizedTitle == title)
    }

    @Test(arguments: [
        (unit: Volume.Unit.cubicFeet, style: LocalizationStyle.short, description: "cu ft"),
        (.liters, .short, "l"),
        (.cubicFeet, .full, "cubic feet"),
        (.liters, .full, "liters")
    ])
    func localizedDescription(unit: Volume.Unit, style: LocalizationStyle, description: String) {
        #expect(unit.localizedDescription(for: style) == description)
    }

    @Test(arguments: [
        (unit: Volume.Unit.cubicFeet, quantity: 0.0, style: LocalizationStyle.short, output: "0 cu ft"),
        (.liters, 0, .short, "0 l"),
        (.cubicFeet, 0, .full, "0 cubic feet"),
        (.liters, 0, .full, "0 liters"),
        (.cubicFeet, 1, .full, "1 cubic foot"),
        (.liters, 1, .full, "1 liter")
    ])
    func quantity(unit: Volume.Unit, quantity: Double, style: LocalizationStyle, output: String) {
        #expect(unit.localization(for: .quantity(quantity, style)) == output)
    }
}
