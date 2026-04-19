import Testing
@testable import DiveKit

extension GasCalculatorImperialSaltwaterTestCase {

    // MARK: bestBlend(for:partialPressure:using:)

    @Test
    func testBestBlendValidInput() throws {
        // Given
        let depth: Depth = 111.0
        let partialPressure: PartialPressure<Oxygen> = 1.4

        // When
        try expectCalculation(
            sut.bestBlend(for: depth, partialPressure: partialPressure, using: physicsCalculator)) { result, configuration in
                // Then
                expectEqual(result.fractionalPressure(of: .oxygen), 0.32)
                expectEqual(configuration, sut.configuration)
            }
    }

    @Test
    func testBestBlendInvalidDepthInput() throws {
        // Given
        let depth: Depth = -111.0
        let partialPressure: PartialPressure<Oxygen> = 1.4
        expectedError = .negative(depth, "GasCalculator.bestBlend(for:partialPressure:using:)")

        // When
        try expectThrowsError(
            when: sut.bestBlend(for: depth, partialPressure: partialPressure, using: physicsCalculator),
            then: expectedError) {
                expectEqual($0.localizationKey, "dive.kit.error.negative.depth")
            }
    }

    @Test
    func testBestBlendInvalidOxygenPartialPressureInput() throws {
        // Given
        let depth: Depth = 111.0
        let partialPressure: PartialPressure<Oxygen> = -1.4
        expectedError = .negative(partialPressure, "GasCalculator.bestBlend(for:partialPressure:using:)")

        // When
        try expectThrowsError(
            when: sut.bestBlend(for: depth, partialPressure: partialPressure, using: physicsCalculator),
            then: expectedError) {
                expectEqual($0.localizationKey, "dive.kit.error.negative.partial.pressure")
            }
    }

    @Test
    func testBestBlendRejectsZeroOxygenPartialPressure() throws {
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
                expectEqual($0.localizationKey, "dive.kit.error.range.lower.bound")
            }
    }
}
