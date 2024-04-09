import XCTest
@testable import DiveKit

extension GasCalculatorImperialSaltwaterTestCase {
    
    // MARK: bestBlend(for:fractionOxygen:using:)
    
    func testBestBlendValidInput() throws {
        // Given
        let depth: Depth = 111.0
        let fractionOxygen: FractionalPressure = 1.4
        
        // When
        XCTAssertCalculation(
            try sut.bestBlend( for: depth, fractionOxygen: fractionOxygen, using: physicsCalculator)) { result, configuration in
                // Then
                XCTAssertEqual(result.partialPressure(of: .oxygen).fractionalPressure, 0.32)
                XCTAssertEqual(configuration, sut.configuration)
            }
    }
    
    func testBestBlendInvalidDepthInput() throws {
        // Given
        let depth: Depth = -111.0
        let fractionOxygen: FractionalPressure = 1.4
        expectedError = .input(.negative(.depth(depth)), "GasCalculator.bestBlend(for:fractionOxygen:using:)")
        
        // When
        try XCTAssertThrowsError(
            when: sut.bestBlend(for: depth, fractionOxygen: fractionOxygen, using: physicsCalculator),
            then: expectedError) {
                XCTAssertEqual($0.localizationKey, "negative.depth")
            }
    }
    
    func testBestBlendInvalidFractionOxygenInput() throws {
        // Given
        let depth: Depth = 111.0
        let fractionOxygen: FractionalPressure = -1.4
        expectedError = .input(.negative(.fractionalPressure(fractionOxygen)), "GasCalculator.bestBlend(for:fractionOxygen:using:)")
        
        // When
        try XCTAssertThrowsError(
            when: sut.bestBlend( for: depth, fractionOxygen: fractionOxygen, using: physicsCalculator),
            then: expectedError) {
                XCTAssertEqual($0.localizationKey, "negative.fractional.pressure")
            }
    }
}
