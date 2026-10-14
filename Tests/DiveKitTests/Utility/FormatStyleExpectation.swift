import DiveKitLocalization

struct FormatStyleExpectation<Decimal: DecimalUnitLocalizable> {
    let input: Decimal
    let style: DecimalUnitFormatStyle<Decimal>
    let output: String
}
