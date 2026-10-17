import Testing
@testable import DiveKit

extension GasCalculatorImperialSaltwaterTests {

    // MARK: partialPressure(of:at:using:)

    @Test
    func partialPressureValidInput() async throws {
        try await given {
            let fractionalPressure = try FractionalPressure(of: .oxygen, fractionalPressure: 0.21)
            let depth: Depth = 33.0
            return (fractionalPressure: fractionalPressure, depth: depth)
        } when: { input in
            try self.sut.partialPressure(
                of: input.fractionalPressure,
                at: input.depth,
                using: self.physicsCalculator)
        } then: { _, calculation in
            try expectCalculation(calculation) { result, configuration in
                    #expect(result.value == 0.42)
                    #expect(result.unit == .atmospheres)
                    #expect(configuration == self.sut.configuration)
            }
        }
    }

    @Test(.tags(.error))
    func partialPressureInvalidInput() async throws {
        try await given {
            let fractionalPressure = try FractionalPressure(of: .oxygen, fractionalPressure: 0.21)
            let depth: Depth = -33.0
            self.expectedError = .negative(depth, "GasCalculator.partialPressure(of:at:using:)")
            return (fractionalPressure: fractionalPressure, depth: depth)
        } when: { input in
            Result { try self.sut.partialPressure(of: input.fractionalPressure, at: input.depth, using: self.physicsCalculator) }
        } then: { _, result in
            try expectThrowsError(when: result.get(), then: self.expectedError) {
                #expect($0.localizationValue == "dive.kit.error.negative.depth")
            }
        }
    }

    // MARK: partialPressure(of:in:at:using:)

    @Test
    func partialPressureBlendedValidInput() async throws {
        try await given {
            let gas = Oxygen()
            let blend = Blend<Blended>.air
            let depth: Depth = 33.0
            return (gas: gas, blend: blend, depth: depth)
        } when: { input in
            try self.sut.partialPressure(
                of: input.gas,
                in: input.blend,
                at: input.depth,
                using: self.physicsCalculator)
        } then: { _, calculation in
            try expectCalculation(calculation) { result, configuration in
                #expect(result.value.isApproximately(0.42))
                #expect(result.unit == .atmospheres)
                #expect(configuration == self.sut.configuration)
            }
        }
    }

    @Test(.tags(.error))
    func partialPressureBlendedInvalidInput() async throws {
        try await given {
            let gas = Oxygen()
            let blend = Blend<Blended>.air
            let depth: Depth = -33.0
            self.expectedError = .negative(depth, "GasCalculator.partialPressure(of:in:at:using:)")
            return (gas: gas, blend: blend, depth: depth)
        } when: { input in
            Result { try self.sut.partialPressure(of: input.gas, in: input.blend, at: input.depth, using: self.physicsCalculator) }
        } then: { _, result in
            try expectThrowsError(when: result.get(), then: self.expectedError) {
                #expect($0.localizationValue == "dive.kit.error.negative.depth")
            }
        }
    }

    // MARK: partialPressure(of:blending:at:using:)

    @Test
    func partialPressureUnblendedValidInput() async throws {
        try await given {
            let gas = Oxygen()
            let blend = try Blend()
                .adding(.oxygen, pressure: 0.21)
                .filling(with: .nitrogen)
            let depth: Depth = 33.0
            return (gas: gas, blend: blend, depth: depth)
        } when: { input in
            try self.sut.partialPressure(
                of: input.gas,
                blending: input.blend,
                at: input.depth,
                using: self.physicsCalculator)
        } then: { _, calculation in
            try expectCalculation(calculation) { result, configuration in
                #expect(result.value == 0.42)
                #expect(result.unit == .atmospheres)
                #expect(configuration == self.sut.configuration)
            }
        }
    }

    @Test(.tags(.error))
    func partialPressureUnblendedInvalidBlendInput() async throws {
        try await given {
            let gas = Oxygen()
            let oxygenFraction = 0.21
            let blend = try Blend<Unblended>(.init(of: .oxygen, fractionalPressure: 0.21))
            let depth: Depth = 33.0
            self.expectedError = .blend(.totalPressure(oxygenFraction, blend), "GasCalculator.partialPressure(of:blending:at:using:)")
            return (gas: gas, blend: blend, depth: depth)
        } when: { input in
            Result { try self.sut.partialPressure(of: input.gas, blending: input.blend, at: input.depth, using: self.physicsCalculator) }
        } then: { _, result in
            try expectThrowsError(when: result.get(), then: self.expectedError) {
                #expect($0.localizationValue == "dive.kit.error.blend.total.pressure")
            }
        }
    }

    @Test(.tags(.error))
    func partialPressureUnblendedInvalidInput() async throws {
        try await given {
            let gas = Oxygen()
            let blend = try Blend()
                .adding(.oxygen, pressure: 0.21)
                .filling(with: .nitrogen)
            let depth: Depth = -33.0
            self.expectedError = .negative(depth, "GasCalculator.partialPressure(of:blending:at:using:)")
            return (gas: gas, blend: blend, depth: depth)
        } when: { input in
            Result { try self.sut.partialPressure(of: input.gas, blending: input.blend, at: input.depth, using: self.physicsCalculator) }
        } then: { _, result in
            try expectThrowsError(when: result.get(), then: self.expectedError) {
                #expect($0.localizationValue == "dive.kit.error.negative.depth")
            }
        }
    }
}
