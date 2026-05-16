import Testing
@testable import DiveKit

extension GasCalculatorImperialSaltwaterTestCase {

    // MARK: partialPressure(of:at:using:)

    @Test
    func partialPressureValidInput() async throws {
        try await given {
            let fractionalPressure = try FractionalPressure(of: .oxygen, fractionalPressure: 0.21)
            let depth: Depth = 33.0
            return {
                try expectCalculation(
                    self.sut.partialPressure(
                        of: fractionalPressure,
                        at: depth,
                        using: self.physicsCalculator)) { result, configuration in
                            #expect(result.value == 0.42)
                            #expect(result.unit == .atmospheres)
                            #expect(configuration == self.sut.configuration)
                    }
            }
        } when: { operation in
            try operation()
        }
    }

    @Test(.tags(.error))
    func partialPressureInvalidInput() async throws {
        try await given {
            let fractionalPressure = try FractionalPressure(of: .oxygen, fractionalPressure: 0.21)
            let depth: Depth = -33.0
            self.expectedError = .negative(depth, "GasCalculator.partialPressure(of:at:using:)")
            return {
                try expectThrowsError(
                    when: self.sut.partialPressure(of: fractionalPressure, at: depth, using: self.physicsCalculator),
                    then: self.expectedError) {
                        #expect($0.localizationValue == "dive.kit.error.negative.depth")
                    }
            }
        } when: { operation in
            try operation()
        }
    }

    // MARK: partialPressure(of:in:at:using:)

    @Test
    func partialPressureBlendedValidInput() async throws {
        try await given {
            let gas = Oxygen()
            let blend = Blend<Blended>.air
            let depth: Depth = 33.0
            return {
                try expectCalculation(
                    self.sut.partialPressure(
                        of: gas,
                        in: blend,
                        at: depth,
                        using: self.physicsCalculator)) { result, configuration in
                            #expect(result.value == 0.418)
                            #expect(result.unit == .atmospheres)
                            #expect(configuration == self.sut.configuration)
                        }
            }
        } when: { operation in
            try operation()
        }
    }

    @Test(.tags(.error))
    func partialPressureBlendedInvalidInput() async throws {
        try await given {
            let gas = Oxygen()
            let blend = Blend<Blended>.air
            let depth: Depth = -33.0
            self.expectedError = .negative(depth, "GasCalculator.partialPressure(of:in:at:using:)")
            return {
                try expectThrowsError(
                    when: self.sut.partialPressure(of: gas, in: blend, at: depth, using: self.physicsCalculator),
                    then: self.expectedError) {
                        #expect($0.localizationValue == "dive.kit.error.negative.depth")
                    }
            }
        } when: { operation in
            try operation()
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
            return {
                try expectCalculation(
                    self.sut.partialPressure(
                        of: gas,
                        blending: blend,
                        at: depth,
                        using: self.physicsCalculator)) { result, configuration in
                            #expect(result.value == 0.42)
                            #expect(result.unit == .atmospheres)
                            #expect(configuration == self.sut.configuration)
                        }
            }
        } when: { operation in
            try operation()
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
            return {
                try expectThrowsError(
                    when: self.sut.partialPressure(of: gas, blending: blend, at: depth, using: self.physicsCalculator),
                    then: self.expectedError) {
                        #expect($0.localizationValue == "dive.kit.error.blend.total.pressure")
                    }
            }
        } when: { operation in
            try operation()
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
            return {
                try expectThrowsError(
                    when: self.sut.partialPressure(of: gas, blending: blend, at: depth, using: self.physicsCalculator),
                    then: self.expectedError) {
                        #expect($0.localizationValue == "dive.kit.error.negative.depth")
                    }
            }
        } when: { operation in
            try operation()
        }
    }
}
