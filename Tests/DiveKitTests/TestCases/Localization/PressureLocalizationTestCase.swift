import Testing
@testable import DiveKit

@Suite("Pressure Localization", .tags(.localization))
struct PressureLocalizationTestCase {
    @Test(arguments: [
        (unit: Pressure.Unit.psi, title: "Pressure"),
        (.bar, "Pressure"),
        (.atmospheres, "Pressure")
    ])
    func localizedTitle(unit: Pressure.Unit, title: String) {
        #expect(unit.localizedTitle == title)
    }

    @Test(arguments: [
        (unit: Pressure.Unit.psi, style: LocalizationStyle.short, description: "psi"),
        (.bar, .short, "bar"),
        (.atmospheres, .short, "atm"),
        (.psi, .full, "pounds per square inch"),
        (.bar, .full, "bar"),
        (.atmospheres, .full, "atmospheres")
    ])
    func localizedDescription(unit: Pressure.Unit, style: LocalizationStyle, description: String) {
        #expect(unit.localizedDescription(for: style) == description)
    }

    @Test(arguments: [
        (unit: Pressure.Unit.psi, quantity: 0.0, style: LocalizationStyle.short, output: "0 psi"),
        (.bar, 0, .short, "0 bar"),
        (.atmospheres, 0, .short, "0 atm"),
        (.psi, 0, .full, "0 pounds per square inch"),
        (.bar, 0, .full, "0 bar"),
        (.atmospheres, 0, .full, "0 atmospheres"),
        (.psi, 1, .full, "1 pound per square inch"),
        (.bar, 1, .full, "1 bar"),
        (.atmospheres, 1, .full, "1 atmosphere")
    ])
    func quantity(unit: Pressure.Unit, quantity: Double, style: LocalizationStyle, output: String) {
        #expect(unit.localization(for: .quantity(quantity, style)) == output)
    }
}
