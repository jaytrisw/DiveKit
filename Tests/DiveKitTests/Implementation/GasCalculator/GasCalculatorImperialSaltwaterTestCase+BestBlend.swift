import TestUtility
@testable import DiveKit

extension GasCalculatorImperialSaltwaterTestCase {

    // MARK: bestBlend(for:fractionOxygen:using:)

    func testBestBlendValidInput() throws {
        // Given
        let depth: Depth = 111.0
        let fractionOxygen: FractionalPressure = 1.4

        // When
        XCTAssertCalculation(
            try sut.bestBlend(
                for: depth,
                fractionOxygen: fractionOxygen,
                using: physicsCalculator)) { result, configuration in
                    // Then
                    XCTAssertEqual(result.partialPressure(of: .oxygen).value, 0.32)
                    XCTAssertEqual(configuration, sut.configuration)
                }
    }

    func testBestBlendInvalidDepthInput() throws {
        // Given
        let depth: Depth = -111.0
        let fractionOxygen: FractionalPressure = 1.4

        // When
        XCTAssertThrowsError(
            try sut.bestBlend(
                for: depth,
                fractionOxygen: fractionOxygen,
                using: physicsCalculator),
            as: Error<Depth>.self) { error in
                // Then
                XCTAssertEqual(error.value, depth)
                XCTAssertEqual(error.message.key, "dive.kit.gas.calculator.negative.depth")
                XCTAssertEqual(error.callSite, "GasCalculator.bestBlend(for:fractionOxygen:using:)")
            }
    }

    func testBestBlendInvalidFractionOxygenInput() throws {
        // Given
        let depth: Depth = 111.0
        let fractionOxygen: FractionalPressure = -1.4

        // When
        XCTAssertThrowsError(
            try sut.bestBlend(
                for: depth,
                fractionOxygen: fractionOxygen,
                using: physicsCalculator),
            as: Error<FractionalPressure>.self) { error in
                // Then
                XCTAssertEqual(error.value, fractionOxygen)
                XCTAssertEqual(error.message.key, "dive.kit.gas.calculator.negative.fraction.oxygen")
                XCTAssertEqual(error.callSite, "GasCalculator.bestBlend(for:fractionOxygen:using:)")
            }
    }

}
