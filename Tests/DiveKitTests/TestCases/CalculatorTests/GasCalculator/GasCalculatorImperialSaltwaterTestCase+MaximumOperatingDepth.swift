import XCTest
@testable import DiveKit

extension GasCalculatorImperialSaltwaterTestCase {

    // MARK: maximumOperatingDepth(for:in:)

    func testMaximumOperatingDepthValidInput() throws {
        let fractionOxygen: FractionalPressure = 1.4
        let blend = Blend<Blended>.enrichedAir(0.32)

        // When
        try XCTAssertCalculation(
            sut.maximumOperatingDepth(for: fractionOxygen, in: blend)) { result, configuration in
                // Then
                XCTAssertEqual(result.value, 111.3749975413084)
                XCTAssertEqual(result.unit, .feet)
                XCTAssertEqual(configuration, sut.configuration)
            }
    }

    func testMaximumOperatingDepthInvalidInput() throws {
        let fractionOxygen: FractionalPressure = -1.4
        let blend = Blend<Blended>.enrichedAir(0.32)
        expectedError = .negative(fractionOxygen, "GasCalculator.maximumOperatingDepth(for:in:)")

        // When
        try XCTAssertThrowsError(
            when: sut.maximumOperatingDepth(for: fractionOxygen, in: blend),
            then: expectedError) {
                XCTAssertEqual($0.localizationKey, "dive.kit.error.negative.fractional.pressure")
                XCTAssertNotEqual($0.localizedDescription, $0.localizationKey)
            }
    }
}
