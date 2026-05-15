import XCTest
@testable import DiveKit

extension GasCalculatorImperialSaltwaterTestCase {

    // MARK: bestBlend(for:partialPressure:using:)

    func testBestBlendValidInput() throws {
        // Given
        let depth: Depth = 111.0
        let partialPressure: PartialPressure<Oxygen> = 1.4

        // When
        try XCTAssertCalculation(
            sut.bestBlend(for: depth, partialPressure: partialPressure, using: physicsCalculator)) { result, configuration in
                // Then
                XCTAssertEqual(result.fractionalPressure(of: .oxygen), 0.32)
                XCTAssertEqual(configuration, sut.configuration)
            }
    }

    func testBestBlendInvalidDepthInput() throws {
        // Given
        let depth: Depth = -111.0
        let partialPressure: PartialPressure<Oxygen> = 1.4
        expectedError = .negative(depth, "GasCalculator.bestBlend(for:partialPressure:using:)")

        // When
        try XCTAssertThrowsError(
            when: sut.bestBlend(for: depth, partialPressure: partialPressure, using: physicsCalculator),
            then: expectedError) {
                XCTAssertEqual($0.localizationValue, "dive.kit.error.negative.depth")
            }
    }

    func testBestBlendInvalidOxygenPartialPressureInput() throws {
        // Given
        let depth: Depth = 111.0
        let partialPressure: PartialPressure<Oxygen> = -1.4
        expectedError = .negative(partialPressure, "GasCalculator.bestBlend(for:partialPressure:using:)")

        // When
        try XCTAssertThrowsError(
            when: sut.bestBlend(for: depth, partialPressure: partialPressure, using: physicsCalculator),
            then: expectedError) {
                XCTAssertEqual($0.localizationValue, "dive.kit.error.negative.partial.pressure")
            }
    }

    func testBestBlendRejectsZeroOxygenPartialPressure() throws {
        // Given
        let depth: Depth = 111.0
        let partialPressure: PartialPressure<Oxygen> = 0
        expectedError = .range(
            .lowerBound(0, 0),
            "GasCalculator.bestBlend(for:partialPressure:using:)")

        // When / Then
        try XCTAssertThrowsError(
            when: sut.bestBlend(for: depth, partialPressure: partialPressure, using: physicsCalculator),
            then: expectedError) {
                XCTAssertEqual($0.localizationValue, "dive.kit.error.range.lower.bound")
            }
    }
}
