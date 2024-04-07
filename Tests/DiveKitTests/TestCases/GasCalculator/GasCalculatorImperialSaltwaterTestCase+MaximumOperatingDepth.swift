import XCTest
@testable import DiveKit

extension GasCalculatorImperialSaltwaterTestCase {

    // MARK: maximumOperatingDepth(for:in:)

    func testMaximumOperatingDepthValidInput() throws {
        let fractionOxygen: FractionalPressure = 1.4
        let blend = Blend<Blended>.enrichedAir(0.32)

        // When
        XCTAssertCalculation(
            try sut.maximumOperatingDepth(for: fractionOxygen, in: blend)) { result, configuration in
                // Then
                XCTAssertEqual(result.decimal.value, 111.3749975413084)
                XCTAssertEqual(result.unit, .feet)
                XCTAssertEqual(configuration, sut.configuration)
            }
    }

    func testMaximumOperatingDepthInvalidInput() throws {
        let fractionOxygen: FractionalPressure = -1.4
        let blend = Blend<Blended>.enrichedAir(0.32)

        // When
        XCTAssertThrowsError(
            try sut.maximumOperatingDepth(for: fractionOxygen, in: blend),
            as: Error<FractionalPressure>.self) { error in
                // Then
                XCTAssertEqual(error.value, fractionOxygen)
                XCTAssertEqual(error.message.key, "dive.kit.gas.calculator.negative.fraction.oxygen")
                XCTAssertEqual(error.callSite, "GasCalculator.maximumOperatingDepth(for:in:)")
            }
    }

}
