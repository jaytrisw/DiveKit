import Testing
@testable import DiveKit
import DiveKitTestSupport

/// Titles, descriptions and quantities of every depth, mass, pressure and
/// volume unit, resolved through the shipping catalog.
@Suite("Unit localization", .tags(.localization))
struct UnitLocalizationTests {
    enum Call: Sendable, CustomTestStringConvertible {
        case title
        case description(LocalizationStyle)
        case quantity(Double, LocalizationStyle)

        var testDescription: String {
            switch self {
                case .title: "title"
                case let .description(style): "description(\(style))"
                case let .quantity(value, style): "quantity(\(value), \(style))"
            }
        }
    }

    struct Expectation: Sendable, CustomTestStringConvertible {
        let unit: String
        let call: Call
        let expected: String
        let localize: @Sendable (Call) -> String

        var testDescription: String {
            "\(unit) \(call.testDescription)"
        }
    }

    /// The expected text for each call, with quantities of 0 and 1.
    struct Texts {
        let title: String
        let shortDescription: String
        let fullDescription: String
        let shortZero: String
        let fullZero: String
        let fullOne: String
    }

    static func cases<Unit: LocalizationProviding & Sendable>(
        _ unit: Unit,
        _ texts: Texts) -> [Expectation] where Unit.Component == LocalizationComponent, Unit.Style == LocalizationStyle {
            let localize: @Sendable (Call) -> String = { call in
                switch call {
                    case .title: unit.localizedTitle
                    case let .description(style): unit.localizedDescription(for: style)
                    case let .quantity(value, style): unit.localization(for: .quantity(value, style))
                }
            }
            return [
                (Call.title, texts.title),
                (.description(.short), texts.shortDescription),
                (.description(.full), texts.fullDescription),
                (.quantity(.zero, .short), texts.shortZero),
                (.quantity(.zero, .full), texts.fullZero),
                (.quantity(1, .full), texts.fullOne)
            ].map { Expectation(unit: String(describing: unit), call: $0.0, expected: $0.1, localize: localize) }
        }

    static let expectations: [Expectation] =
        cases(
                Depth.Unit.feet,
                Texts(
                    title: "Depth",
                    shortDescription: "ft",
                    fullDescription: "feet",
                    shortZero: "0 ft",
                    fullZero: "0 feet",
                    fullOne: "1 foot"))
            + cases(
                Depth.Unit.meters,
                Texts(
                    title: "Depth",
                    shortDescription: "m",
                    fullDescription: "meters",
                    shortZero: "0 m",
                    fullZero: "0 meters",
                    fullOne: "1 meter"))
            + cases(
                Mass.Unit.pounds,
                Texts(
                    title: "Mass",
                    shortDescription: "lbs",
                    fullDescription: "pounds",
                    shortZero: "0 lbs",
                    fullZero: "0 pounds",
                    fullOne: "1 pound"))
            + cases(
                Mass.Unit.kilograms,
                Texts(
                    title: "Mass",
                    shortDescription: "kg",
                    fullDescription: "kilograms",
                    shortZero: "0 kg",
                    fullZero: "0 kilograms",
                    fullOne: "1 kilogram"))
            + cases(
                Pressure.Unit.psi,
                Texts(
                    title: "Pressure",
                    shortDescription: "psi",
                    fullDescription: "pounds per square inch",
                    shortZero: "0 psi",
                    fullZero: "0 pounds per square inch",
                    fullOne: "1 pound per square inch"))
            + cases(
                Pressure.Unit.bar,
                Texts(
                    title: "Pressure",
                    shortDescription: "bar",
                    fullDescription: "bar",
                    shortZero: "0 bar",
                    fullZero: "0 bar",
                    fullOne: "1 bar"))
            + cases(
                Pressure.Unit.atmospheres,
                Texts(
                    title: "Pressure",
                    shortDescription: "atm",
                    fullDescription: "atmospheres",
                    shortZero: "0 atm",
                    fullZero: "0 atmospheres",
                    fullOne: "1 atmosphere"))
            + cases(
                Volume.Unit.cubicFeet,
                Texts(
                    title: "Volume",
                    shortDescription: "cu ft",
                    fullDescription: "cubic feet",
                    shortZero: "0 cu ft",
                    fullZero: "0 cubic feet",
                    fullOne: "1 cubic foot"))
            + cases(
                Volume.Unit.liters,
                Texts(
                    title: "Volume",
                    shortDescription: "l",
                    fullDescription: "liters",
                    shortZero: "0 l",
                    fullZero: "0 liters",
                    fullOne: "1 liter"))

    @Test(arguments: expectations)
    func localizes(expectation: Expectation) async {
        await withTestLocalization(.test) {
            await given {
                expectation
            } when: { expectation in
                expectation.localize(expectation.call)
            } then: { expectation, result in
                #expect(result == expectation.expected)
            }
        }
    }
}
