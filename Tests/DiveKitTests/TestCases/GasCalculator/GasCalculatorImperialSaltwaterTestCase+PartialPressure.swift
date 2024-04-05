import XCTest
@testable import DiveKit

extension GasCalculatorImperialSaltwaterTestCase {

    // MARK: partialPressure(of:at:using:)

    func testPartialPressureValidInput() throws {
        // Given
        let partialPressure = PartialPressure(.oxygen, value: 0.21)
        let depth: Depth = 33.0

        // When
        XCTAssertCalculation(try sut.partialPressure(
            of: partialPressure,
            at: depth,
            using: physicsCalculator)) { result, configuration in
                // Then
                XCTAssertEqual(result.value, 0.42)
                XCTAssertEqual(configuration, sut.configuration)
            }
    }

    func testPartialPressureInvalidInput() throws {
        // Given
        let partialPressure = PartialPressure(.oxygen, value: 0.21)
        let depth: Depth = -33.0

        // When
        XCTAssertThrowsError(try sut.partialPressure(
            of: partialPressure,
            at: depth,
            using: physicsCalculator), as: Error<Depth>.self) { error in
                // Then
                XCTAssertEqual(error.value, depth)
                XCTAssertEqual(error.message.key, "dive.kit.gas.calculator.negative.depth")
                XCTAssertEqual(error.callSite, "GasCalculator.partialPressure(of:at:using:)")
            }
    }

    // MARK: partialPressure(of:in:at:using:)

    func testPartialPressureBlendedValidInput() throws {
        // Given
        let gas = Oxygen()
        let blend = Blend<Blended>.air
        let depth: Depth = 33.0

        // When
        XCTAssertCalculation(try sut.partialPressure(
            of: gas,
            in: blend,
            at: depth,
            using: physicsCalculator)) { result, configuration in
                // Then
                XCTAssertEqual(result.value, 0.418)
                XCTAssertEqual(configuration, sut.configuration)
            }
    }

    func testPartialPressureBlendedInvalidInput() throws {
        // Given
        let gas = Oxygen()
        let blend = Blend<Blended>.air
        let depth: Depth = -33.0

        // When
        XCTAssertThrowsError(try sut.partialPressure(
            of: gas,
            in: blend,
            at: depth,
            using: physicsCalculator), as: Error<Depth>.self) { error in
                // Then
                XCTAssertEqual(error.value, depth)
                XCTAssertEqual(error.message.key, "dive.kit.gas.calculator.negative.depth")
                XCTAssertEqual(error.callSite, "GasCalculator.partialPressure(of:in:at:using:)")
            }
    }

    // MARK: partialPressure(of:blending:at:using:)

    func testPartialPressureUnblendedValidInput() throws {
        // Given
        let gas = Oxygen()
        let blend = try Blend()
            .adding(.oxygen, pressure: 0.21)
            .filling(with: .nitrogen)
        let depth: Depth = 33.0

        // When
        XCTAssertCalculation(try sut.partialPressure(
            of: gas,
            blending: blend,
            at: depth,
            using: physicsCalculator)) { result, configuration in
                // Then
                XCTAssertEqual(result.value, 0.42)
                XCTAssertEqual(configuration, sut.configuration)
            }
    }

    func testPartialPressureUnblendedInvalidBlendInput() throws {
        // Given
        let gas = Oxygen()
        let blend = try Blend()
            .adding(.oxygen, pressure: 0.21)
        let depth: Depth = 33.0

        // When
        XCTAssertThrowsError(
            try sut.partialPressure(
                of: gas,
                blending: blend,
                at: depth,
                using: physicsCalculator),
            as: Error<Blend>.self) { error in
                // Then
                XCTAssertEqual(error.value, blend)
                XCTAssertEqual(error.message.key, "dive.kit.gas.calculator.dive.kit.blend.total.pressure")
                XCTAssertEqual(error.callSite, "GasCalculator.partialPressure(of:blending:at:using:)")
            }
    }

    func testPartialPressureUnblendedInvalidInput() throws {
        // Given
        let gas = Oxygen()
        let blend = try Blend()
            .adding(.oxygen, pressure: 0.21)
            .filling(with: .nitrogen)
        let depth: Depth = -33.0

        // When
        XCTAssertThrowsError(
            try sut.partialPressure(
                of: gas,
                blending: blend,
                at: depth,
                using: physicsCalculator), as: Error<Depth>.self) { error in
                    // Then
                    XCTAssertEqual(error.value, depth)
                    XCTAssertEqual(error.message.key, "dive.kit.gas.calculator.negative.depth")
                    XCTAssertEqual(error.callSite, "GasCalculator.partialPressure(of:blending:at:using:)")
                }
    }

}
