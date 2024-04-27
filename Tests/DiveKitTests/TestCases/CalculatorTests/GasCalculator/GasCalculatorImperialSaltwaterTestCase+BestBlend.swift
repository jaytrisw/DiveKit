import XCTest
@testable import DiveKit

extension GasCalculatorImperialSaltwaterTestCase {
    
    // MARK: bestBlend(for:fractionOxygen:using:)
    
    func testBestBlendValidInput() throws {
        // Given
        let depth: Depth = 111.0
        let fractionOxygen: FractionalPressure = 1.4
        
        // When
        try XCTAssertCalculation(
            sut.bestBlend(for: depth, fractionOxygen: fractionOxygen, using: physicsCalculator)) { result, configuration in
                // Then
                XCTAssertEqual(result.pressure(of: .oxygen), 0.32)
                XCTAssertEqual(configuration, sut.configuration)
            }
    }
    
    func testBestBlendInvalidDepthInput() throws {
        // Given
        let depth: Depth = -111.0
        let fractionOxygen: FractionalPressure = 1.4
        expectedError = .negative(depth, "GasCalculator.bestBlend(for:fractionOxygen:using:)")

        // When
        try XCTAssertThrowsError(
            when: sut.bestBlend(for: depth, fractionOxygen: fractionOxygen, using: physicsCalculator),
            then: expectedError) {
                XCTAssertEqual($0.localizationKey, "dive.kit.error.negative.depth")
            }
    }
    
    func testBestBlendInvalidFractionOxygenInput() throws {
        // Given
        let depth: Depth = 111.0
        let fractionOxygen: FractionalPressure = -1.4
        expectedError = .negative(fractionOxygen, "GasCalculator.bestBlend(for:fractionOxygen:using:)")

        // When
        try XCTAssertThrowsError(
            when: sut.bestBlend( for: depth, fractionOxygen: fractionOxygen, using: physicsCalculator),
            then: expectedError) {
                XCTAssertEqual($0.localizationKey, "dive.kit.error.negative.fractional.pressure")
            }
    }
}
