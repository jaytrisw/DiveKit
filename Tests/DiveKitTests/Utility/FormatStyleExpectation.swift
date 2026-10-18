import DiveKitLocalization

struct FormatStyleExpectation<Decimal: DecimalUnitLocalizable>: Sendable {
    let input: Decimal
    let style: DecimalUnitFormatStyle<Decimal>
    let output: String
}
