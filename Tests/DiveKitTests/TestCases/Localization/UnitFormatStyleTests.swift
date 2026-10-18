import Foundation
import Testing
@testable import DiveKit
import DiveKitTestSupport

/// Format styles for every depth, mass, pressure and volume unit: the active
/// locale, explicit German and English locales and precision, and singular and
/// plural full descriptions.
@Suite("Unit format styles", .tags(.localization))
struct UnitFormatStyleTests {
    /// One formatted value, with its unit type erased so every unit shares a test.
    struct Expectation: Sendable, CustomTestStringConvertible {
        let testDescription: String
        let format: @Sendable () -> String
        let expected: String

        init<Value: DecimalUnitLocalizable>(_ value: Value, _ style: DecimalUnitFormatStyle<Value>, _ expected: String) {
            testDescription = "\(Value.self)(\(value.value)) → \(expected)"
            format = { value.formatted(style) }
            self.expected = expected
        }
    }

    static let expectations: [Expectation] = [
        .init(Depth(15), .depth(.feet, style: .full), "15 feet"),
        .init(Depth(33), .depth(.feet, style: .short).precision(.fractionLength(1)).locale(.german), "33,0 ft"),
        .init(Depth(10.3), .depth(.meters, style: .short).precision(.fractionLength(1)).locale(.german), "10,3 m"),
        .init(Depth(33), .depth(.feet, style: .short).precision(.fractionLength(1)).locale(.english), "33.0 ft"),
        .init(Depth(33), .depth(.feet, style: .short).locale(.german), "33 ft"),
        .init(Depth(1), .depth(.feet, style: .full).locale(.english), "1 foot"),
        .init(Depth(2), .depth(.feet, style: .full).locale(.english), "2 feet"),
        .init(Depth(1), .depth(.meters, style: .full).locale(.english), "1 meter"),
        .init(Depth(2), .depth(.meters, style: .full).locale(.english), "2 meters"),
        .init(Mass(15), .mass(.pounds, style: .full), "15 pounds"),
        .init(Mass(33), .mass(.pounds, style: .short).precision(.fractionLength(1)).locale(.german), "33,0 lbs"),
        .init(Mass(10.3), .mass(.kilograms, style: .short).precision(.fractionLength(1)).locale(.german), "10,3 kg"),
        .init(Mass(33), .mass(.pounds, style: .short).precision(.fractionLength(1)).locale(.english), "33.0 lbs"),
        .init(Mass(1), .mass(.pounds, style: .full).locale(.english), "1 pound"),
        .init(Mass(2), .mass(.pounds, style: .full).locale(.english), "2 pounds"),
        .init(Mass(1), .mass(.kilograms, style: .full).locale(.english), "1 kilogram"),
        .init(Mass(2), .mass(.kilograms, style: .full).locale(.english), "2 kilograms"),
        .init(Pressure(15), .pressure(.atmospheres, style: .full), "15 atmospheres"),
        .init(Pressure(33), .pressure(.atmospheres, style: .short).precision(.fractionLength(1)).locale(.german), "33,0 atm"),
        .init(Pressure(10.3), .pressure(.bar, style: .short).precision(.fractionLength(1)).locale(.german), "10,3 bar"),
        .init(Pressure(33), .pressure(.atmospheres, style: .short).precision(.fractionLength(1)).locale(.english), "33.0 atm"),
        .init(Pressure(1), .pressure(.psi, style: .full).locale(.english), "1 pound per square inch"),
        .init(Pressure(2), .pressure(.psi, style: .full).locale(.english), "2 pounds per square inch"),
        .init(Pressure(1), .pressure(.atmospheres, style: .full).locale(.english), "1 atmosphere"),
        .init(Pressure(2), .pressure(.atmospheres, style: .full).locale(.english), "2 atmospheres"),
        .init(Volume(15), .volume(.cubicFeet, style: .full), "15 cubic feet"),
        .init(Volume(33), .volume(.cubicFeet, style: .short).precision(.fractionLength(1)).locale(.german), "33,0 cu ft"),
        .init(Volume(10.3), .volume(.liters, style: .short).precision(.fractionLength(1)).locale(.german), "10,3 l"),
        .init(Volume(33), .volume(.cubicFeet, style: .short).precision(.fractionLength(1)).locale(.english), "33.0 cu ft"),
        .init(Volume(1), .volume(.cubicFeet, style: .full).locale(.english), "1 cubic foot"),
        .init(Volume(2), .volume(.cubicFeet, style: .full).locale(.english), "2 cubic feet"),
        .init(Volume(1), .volume(.liters, style: .full).locale(.english), "1 liter"),
        .init(Volume(2), .volume(.liters, style: .full).locale(.english), "2 liters")
    ]

    @Test(arguments: expectations)
    func formats(expectation: Expectation) async {
        await withTestLocalization(.test) {
            await given {
                expectation
            } when: { expectation in
                expectation.format()
            } then: { expectation, result in
                #expect(result == expectation.expected)
            }
        }
    }

    @Test
    func formatStyleUsesActiveLocaleWhenNoneIsSpecified() async {
        await withTestLocalization(.test, .german) {
            await given {
                Depth(10.3)
            } when: { sut in
                sut.formatted(.depth(.meters, style: .short))
            } then: { _, result in
                #expect(result == "10,3 m")
            }
        }
    }
}

private extension Locale {
    static var german: Locale {
        .init(identifier: "de_DE")
    }
}
