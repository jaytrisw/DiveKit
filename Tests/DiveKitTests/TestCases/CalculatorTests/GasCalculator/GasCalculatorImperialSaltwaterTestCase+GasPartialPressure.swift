import Testing
@testable import DiveKit

extension GasCalculatorImperialSaltwaterTestCase {

    // MARK: partialPressure(of:at:using:)

    @Test
    func testPartialPressureValidInput() throws {
        // Given
        let fractionalPressure = try FractionalPressure(of: .oxygen, fractionalPressure: 0.21)
        let depth: Depth = 33.0

        // When
        try expectCalculation(
            sut.partialPressure(
                of: fractionalPressure,
                at: depth,
                using: physicsCalculator)) { result, configuration in
                    // Then
                    #expect(result.value == 0.42)
                    #expect(result.unit == .atmospheres)
                    #expect(configuration == sut.configuration)
            }
    }

    @Test
    func testPartialPressureInvalidInput() throws {
        // Given
        let fractionalPressure = try FractionalPressure(of: .oxygen, fractionalPressure: 0.21)
        let depth: Depth = -33.0
        expectedError = .negative(depth, "GasCalculator.partialPressure(of:at:using:)")

        // When
        try expectThrowsError(
            when: sut.partialPressure(of: fractionalPressure, at: depth, using: physicsCalculator),
            then: expectedError) {
                #expect($0.localizationKey == "dive.kit.error.negative.depth")
            }
    }

    // MARK: partialPressure(of:in:at:using:)

    @Test
    func testPartialPressureBlendedValidInput() throws {
        // Given
        let gas = Oxygen()
        let blend = Blend<Blended>.air
        let depth: Depth = 33.0

        // When
        try expectCalculation(
            sut.partialPressure(
                of: gas,
                in: blend,
                at: depth,
                using: physicsCalculator)) { result, configuration in
                    // Then
                    #expect(result.value == 0.418)
                    #expect(result.unit == .atmospheres)
                    #expect(configuration == sut.configuration)
                }
    }

    @Test
    func testPartialPressureBlendedInvalidInput() throws {
        // Given
        let gas = Oxygen()
        let blend = Blend<Blended>.air
        let depth: Depth = -33.0
        expectedError = .negative(depth, "GasCalculator.partialPressure(of:in:at:using:)")

        // When
        try expectThrowsError(
            when: sut.partialPressure(of: gas, in: blend, at: depth, using: physicsCalculator),
            then: expectedError) {
                #expect($0.localizationKey == "dive.kit.error.negative.depth")
            }
    }

    // MARK: partialPressure(of:blending:at:using:)

    @Test
    func testPartialPressureUnblendedValidInput() throws {
        // Given
        let gas = Oxygen()
        let blend = try Blend()
            .adding(.oxygen, pressure: 0.21)
            .filling(with: .nitrogen)
        let depth: Depth = 33.0

        // When
        try expectCalculation(
            sut.partialPressure(
                of: gas,
                blending: blend,
                at: depth,
                using: physicsCalculator)) { result, configuration in
                    // Then
                    #expect(result.value == 0.42)
                    #expect(result.unit == .atmospheres)
                    #expect(configuration == sut.configuration)
                }
    }

    @Test
    func testPartialPressureUnblendedInvalidBlendInput() throws {
        // Given
        let gas = Oxygen()
        let oxygenFraction = 0.21
        let blend = try Blend<Unblended>(.init(of: .oxygen, fractionalPressure: 0.21))
        let depth: Depth = 33.0
        expectedError = .blend(.totalPressure(oxygenFraction, blend), "GasCalculator.partialPressure(of:blending:at:using:)")

        // When
        try expectThrowsError(
            when: sut.partialPressure(of: gas, blending: blend, at: depth, using: physicsCalculator),
            then: expectedError) {
                #expect($0.localizationKey == "dive.kit.error.blend.total.pressure")
            }
    }

    @Test
    func testPartialPressureUnblendedInvalidInput() throws {
        // Given
        let gas = Oxygen()
        let blend = try Blend()
            .adding(.oxygen, pressure: 0.21)
            .filling(with: .nitrogen)
        let depth: Depth = -33.0
        expectedError = .negative(depth, "GasCalculator.partialPressure(of:blending:at:using:)")

        // When
        try expectThrowsError(
            when: sut.partialPressure(of: gas, blending: blend, at: depth, using: physicsCalculator),
            then: expectedError) {
                #expect($0.localizationKey == "dive.kit.error.negative.depth")
            }
    }
}
