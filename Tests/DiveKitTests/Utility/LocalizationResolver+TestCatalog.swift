import Foundation
@testable import DiveKit

extension LocalizationResolver {
    static let diveKitTestCatalog: Self = .init { key, arguments, locale in
        let key = String(localized: key, table: "Localizable", bundle: .module, locale: locale)
        let localizedString = DiveKitTestLocalization.localizedString(for: key, arguments: arguments) ?? key

        return localizedString.applyingTestLocalizationArguments(arguments, locale: locale)
    }
}

private enum DiveKitTestLocalization {
    private static let strings: [String: String] = [
        "dive.kit.error.blend.pressure.range": "Blend pressure should be a decimal between 0.0 and 1.0",
        "dive.kit.error.blend.total.pressure": "Blend pressure should be equal on 1.0",
        "dive.kit.error.negative.depth": "Depth input must not be a negative value",
        "dive.kit.error.negative.fractional.pressure": "Fractional pressure input must not be a negative value",
        "dive.kit.error.negative.minutes": "Minutes input must not be a negative value",
        "dive.kit.error.negative.partial.pressure": "Partial pressure input must not be a negative value",
        "dive.kit.error.negative.pressure": "Pressure input must not be a negative value",
        "dive.kit.error.negative.volume": "Volume input must not be a negative value",
        "dive.kit.error.negative.weight": "Weight input must not be a negative value",
        "dive.kit.error.range.lower.bound": "Input must be greater than the allowed lower bound",
        "dive.kit.error.range.upper.bound": "Input must not exceed the allowed upper bound",
        "dive.kit.error.tank.size.rated.pressure": "Tank rated pressure must not be a negative value",
        "dive.kit.error.tank.size.volume": "Tank volume must not be a negative value",
        "dive.kit.unit.depth.imperial.description.full": "feet",
        "dive.kit.unit.depth.imperial.description.short": "ft",
        "dive.kit.unit.depth.imperial.description.short.quantity": "%.3f ft",
        "dive.kit.unit.depth.metric.description.full": "meters",
        "dive.kit.unit.depth.metric.description.short": "m",
        "dive.kit.unit.depth.metric.description.short.quantity": "%.3f m",
        "dive.kit.unit.depth.title": "Depth",
        "dive.kit.unit.mass.imperial.description.full": "pounds",
        "dive.kit.unit.mass.imperial.description.short": "lbs",
        "dive.kit.unit.mass.metric.description.full": "kilograms",
        "dive.kit.unit.mass.metric.description.short": "kg",
        "dive.kit.unit.mass.metric.description.short.quantity": "%.3f kg",
        "dive.kit.unit.mass.title": "Mass",
        "dive.kit.unit.pressure.atmospheres.description.full": "atmospheres",
        "dive.kit.unit.pressure.atmospheres.description.short": "atm",
        "dive.kit.unit.pressure.atmospheres.description.short.quantity": "%.3f atm",
        "dive.kit.unit.pressure.imperial.description.full": "pounds per square inch",
        "dive.kit.unit.pressure.imperial.description.short": "psi",
        "dive.kit.unit.pressure.imperial.description.short.quantity": "%.3f psi",
        "dive.kit.unit.pressure.metric.description.full": "bar",
        "dive.kit.unit.pressure.metric.description.full.quantity": "%.3f bar",
        "dive.kit.unit.pressure.metric.description.short": "bar",
        "dive.kit.unit.pressure.metric.description.short.quantity": "%.3f bar",
        "dive.kit.unit.pressure.title": "Pressure",
        "dive.kit.unit.rate.description.full": "%@ per minute",
        "dive.kit.unit.rate.description.full.quantity": "%@ per minute",
        "dive.kit.unit.rate.description.short": "%@/min",
        "dive.kit.unit.rate.description.short.quantity": "%@/min",
        "dive.kit.unit.rate.title": "%@ Rate",
        "dive.kit.unit.volume.imperial.description.full": "cubic feet",
        "dive.kit.unit.volume.imperial.description.short": "cu ft",
        "dive.kit.unit.volume.imperial.description.short.quantity": "%.3f cu ft",
        "dive.kit.unit.volume.metric.description.full": "liters",
        "dive.kit.unit.volume.metric.description.short": "l",
        "dive.kit.unit.volume.metric.description.short.quantity": "%.3f l",
        "dive.kit.unit.volume.title": "Volume",
        "test.localization.key": "TEST LOCALIZED STRING"
    ]

    private static let plurals: [String: (one: String, other: String)] = [
        "dive.kit.unit.depth.imperial.description.full.quantity": ("%.3f foot", "%.3f feet"),
        "dive.kit.unit.depth.metric.description.full.quantity": ("%.3f meter", "%.3f meters"),
        "dive.kit.unit.mass.imperial.description.full.quantity": ("%.3f pound", "%.3f pounds"),
        "dive.kit.unit.mass.imperial.description.short.quantity": ("%.3f lb", "%.3f lbs"),
        "dive.kit.unit.mass.metric.description.full.quantity": ("%.3f kilogram", "%.3f kilograms"),
        "dive.kit.unit.pressure.atmospheres.description.full.quantity": ("%.3f atmosphere", "%.3f atmospheres"),
        "dive.kit.unit.pressure.imperial.description.full.quantity": (
            "%.3f pound per square inch",
            "%.3f pounds per square inch"),
        "dive.kit.unit.volume.imperial.description.full.quantity": ("%.3f cubic foot", "%.3f cubic feet"),
        "dive.kit.unit.volume.metric.description.full.quantity": ("%.3f liter", "%.3f liters"),
        "test.localization.key.quantity": (
            "%.3f TEST LOCALIZED STRING WITH QUANTITY",
            "%.3f TEST LOCALIZED STRING WITH QUANTITIES")
    ]

    static func localizedString(for key: String, arguments: [CVarArg]) -> String? {
        if let plural = plurals[key], let quantity = arguments.first as? Double {
            return quantity == 1 ? plural.one : plural.other
        }

        return strings[key]
    }
}

private extension String {
    func applyingTestLocalizationArguments(_ arguments: [CVarArg], locale: Locale) -> String {
        guard !arguments.isEmpty else {
            return self
        }

        return .init(format: self, locale: locale, arguments: arguments)
    }
}
