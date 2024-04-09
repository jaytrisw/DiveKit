import XCTest
@testable import DiveKit

extension GasCalculatorImperialSaltwaterTestCase {

    // MARK: partialPressure(of:at:using:)

    func testPartialPressureValidInput() throws {
        // Given
        let partialPressure = PartialPressure(.oxygen, fractionalPressure: 0.21)
        let depth: Depth = 33.0

        // When
        try XCTAssertCalculation(
            sut.partialPressure(
                of: partialPressure,
                at: depth,
                using: physicsCalculator)) { result, configuration in
                    // Then
                    XCTAssertEqual(result.fractionalPressure, 0.42)
                    XCTAssertEqual(configuration, sut.configuration)
            }
    }

    func testPartialPressureInvalidInput() throws {
        // Given
        let partialPressure = PartialPressure(.oxygen, fractionalPressure: 0.21)
        let depth: Depth = -33.0
        expectedError = .input(.negative(.depth(depth)), "GasCalculator.partialPressure(of:at:using:)")

        // When
        try XCTAssertThrowsError(
            when: sut.partialPressure(of: partialPressure, at: depth, using: physicsCalculator),
            then: expectedError) {
                XCTAssertEqual($0.localizationKey, "negative.depth")
            }
    }

    // MARK: partialPressure(of:in:at:using:)

    func testPartialPressureBlendedValidInput() throws {
        // Given
        let gas = Oxygen()
        let blend = Blend<Blended>.air
        let depth: Depth = 33.0

        // When
        try XCTAssertCalculation(
            sut.partialPressure(
                of: gas,
                in: blend,
                at: depth,
                using: physicsCalculator)) { result, configuration in
                    // Then
                    XCTAssertEqual(result.fractionalPressure, 0.418)
                    XCTAssertEqual(configuration, sut.configuration)
                }
    }

    func testPartialPressureBlendedInvalidInput() throws {
        // Given
        let gas = Oxygen()
        let blend = Blend<Blended>.air
        let depth: Depth = -33.0
        expectedError = .input(.negative(.depth(depth)), "GasCalculator.partialPressure(of:in:at:using:)")

        // When
        try XCTAssertThrowsError(
            when: sut.partialPressure(of: gas, in: blend, at: depth, using: physicsCalculator),
            then: expectedError) {
                XCTAssertEqual($0.localizationKey, "negative.depth")
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
        try XCTAssertCalculation(
            sut.partialPressure(
                of: gas,
                blending: blend,
                at: depth,
                using: physicsCalculator)) { result, configuration in
                    // Then
                    XCTAssertEqual(result.fractionalPressure, 0.42)
                    XCTAssertEqual(configuration, sut.configuration)
                }
    }

    func testPartialPressureUnblendedInvalidBlendInput() throws {
        // Given
        let gas = Oxygen()
        let blend = Blend<Unblended>(.init(.oxygen, fractionalPressure: 0.21))
        let depth: Depth = 33.0
        expectedError = .input(.invalid(.blend(blend)), "GasCalculator.partialPressure(of:blending:at:using:)")

        // When
        try XCTAssertThrowsError(
            when: sut.partialPressure(of: gas, blending: blend, at: depth, using: physicsCalculator),
            then: expectedError) {
                XCTAssertEqual($0.localizationKey, "invalid.blend")
            }
    }

    func testPartialPressureUnblendedInvalidInput() throws {
        // Given
        let gas = Oxygen()
        let blend = try Blend()
            .adding(.oxygen, pressure: 0.21)
            .filling(with: .nitrogen)
        let depth: Depth = -33.0
        expectedError = .input(.negative(.depth(depth)), "GasCalculator.partialPressure(of:blending:at:using:)")

        // When
        try XCTAssertThrowsError(
            when: sut.partialPressure(of: gas, blending: blend, at: depth, using: physicsCalculator),
            then: expectedError) {
                XCTAssertEqual($0.localizationKey, "negative.depth")
            }
    }
}
