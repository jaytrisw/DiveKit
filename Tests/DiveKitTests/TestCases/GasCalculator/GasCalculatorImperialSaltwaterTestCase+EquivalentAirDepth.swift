import XCTest
@testable import DiveKit

extension GasCalculatorImperialSaltwaterTestCase {

    // MARK: equivalentAirDepth(for:with:)

    func testEquivalentAirDepthValidInput() {
        // Given
        let depth: Depth = 80.0
        let blend = Blend<Blended>.enrichedAir(0.4)

        // When
        XCTAssertCalculation(
            try sut.equivalentAirDepth(for: depth, with: blend)) { result, configuration in
                // Then
                XCTAssertEqual(result.decimal.value, 52.82278481012658)
                XCTAssertEqual(result.unit, .feet)
                XCTAssertEqual(configuration, sut.configuration)
            }
    }

    func testEquivalentAirDepthUnblendedValidInput() throws {
        // Given
        let depth: Depth = 80.0
        let blend = try Blend<Unblended>()
            .adding(.oxygen, pressure: 0.4)
            .filling(with: .nitrogen)

        // When
        XCTAssertCalculation(
            try sut.equivalentAirDepth(for: depth, with: blend)) { result, configuration in
                // Then
                XCTAssertEqual(result.decimal.value, 52.82278481012658)
                XCTAssertEqual(result.unit, .feet)
                XCTAssertEqual(configuration, sut.configuration)
            }
    }

    func testEquivalentAirDepthInvalidDepthInput() {
        // Given
        let depth: Depth = -80.0
        let blend = Blend<Blended>.enrichedAir(0.4)

        // When
        XCTAssertThrowsError(
            try sut.equivalentAirDepth(
                for: depth,
                with: blend),
            as: Error<Depth>.self) { error in
                // Then
                XCTAssertEqual(error.value, depth)
                XCTAssertEqual(error.message.key, "dive.kit.gas.calculator.negative.depth")
                XCTAssertEqual(error.callSite, "GasCalculator.equivalentAirDepth(for:with:)")
            }
    }

    func testEquivalentAirDepthUnblendedInvalidBlendInput() throws {
        // Given
        let depth: Depth = 80.0
        let blend = try Blend<Unblended>()
            .adding(.oxygen, pressure: 0.4)

        // When
        XCTAssertThrowsError(
            try sut.equivalentAirDepth(
                for: depth,
                with: blend),
            as: Error<Blend>.self) { error in
                // Then
                XCTAssertEqual(error.value, blend)
                XCTAssertEqual(error.message.key, "dive.kit.gas.calculator.dive.kit.blend.total.pressure")
                XCTAssertEqual(error.callSite, "GasCalculator.equivalentAirDepth(for:with:)")
            }
    }

}
