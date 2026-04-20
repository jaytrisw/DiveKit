import Testing
@testable import DiveKit

extension GasCalculatorImperialSaltwaterTestCase {

    // MARK: bestBlend(for:partialPressure:using:)

    @Test
    func bestBlendValidInput() throws {
        // Given
        let depth: Depth = 111.0
        let partialPressure: PartialPressure<Oxygen> = 1.4

        // When
        try expectCalculation(
            sut.bestBlend(for: depth, partialPressure: partialPressure, using: physicsCalculator)) { result, configuration in
                // Then
                let oxygenFraction = try result.fractionalPressure(of: .oxygen)
                #expect(oxygenFraction.value == 0.32)
                #expect(configuration == sut.configuration)
            }
    }

    @Test(.tags(.error))
    func bestBlendInvalidDepthInput() throws {
        // Given
        let depth: Depth = -111.0
        let partialPressure: PartialPressure<Oxygen> = 1.4
        expectedError = .negative(depth, "GasCalculator.bestBlend(for:partialPressure:using:)")

        // When
        try expectThrowsError(
            when: sut.bestBlend(for: depth, partialPressure: partialPressure, using: physicsCalculator),
            then: expectedError) {
                #expect($0.localizationKey == "dive.kit.error.negative.depth")
            }
    }

    @Test(.tags(.error))
    func bestBlendInvalidOxygenPartialPressureInput() throws {
        // Given
        let depth: Depth = 111.0
        let partialPressure: PartialPressure<Oxygen> = -1.4
        expectedError = .negative(partialPressure, "GasCalculator.bestBlend(for:partialPressure:using:)")

        // When
        try expectThrowsError(
            when: sut.bestBlend(for: depth, partialPressure: partialPressure, using: physicsCalculator),
            then: expectedError) {
                #expect($0.localizationKey == "dive.kit.error.negative.partial.pressure")
            }
    }

    @Test(.tags(.error))
    func bestBlendRejectsZeroOxygenPartialPressure() throws {
        // Given
        let depth: Depth = 111.0
        let partialPressure: PartialPressure<Oxygen> = 0
        expectedError = .range(
            .lowerBound(0, 0),
            "GasCalculator.bestBlend(for:partialPressure:using:)")

        // When / Then
        try expectThrowsError(
            when: sut.bestBlend(for: depth, partialPressure: partialPressure, using: physicsCalculator),
            then: expectedError) {
                #expect($0.localizationKey == "dive.kit.error.range.lower.bound")
            }
    }
}
