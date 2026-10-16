import Testing
@testable import DiveKit

extension GasCalculatorImperialSaltwaterTests {

    // MARK: maximumOperatingDepth(for:in:)

    @Test
    func maximumOperatingDepthForEAN28AtOnePointFour() async throws {
        try await given {
            let partialPressure: PartialPressure<Oxygen> = 1.4
            let blend = try Blend<Blended>.enrichedAir(0.28)
            return (partialPressure: partialPressure, blend: blend)
        } when: { input in
            try self.sut.maximumOperatingDepth(for: input.partialPressure, in: input.blend)
        } then: { _, calculation in
            try expectCalculation(calculation) { result, configuration in
                #expect(abs(result.value - 131.99999719006675) <= 0.0001)
                #expect(result.unit == .feet)
                #expect(configuration == self.sut.configuration)
            }
        }
    }

    @Test
    func maximumOperatingDepthForEAN30AtOnePointFour() async throws {
        try await given {
            let partialPressure: PartialPressure<Oxygen> = 1.4
            let blend = try Blend<Blended>.enrichedAir(0.30)
            return (partialPressure: partialPressure, blend: blend)
        } when: { input in
            try self.sut.maximumOperatingDepth(for: input.partialPressure, in: input.blend)
        } then: { _, calculation in
            try expectCalculation(calculation) { result, configuration in
                #expect(abs(result.value - 120.99999737739564) <= 0.0001)
                #expect(result.unit == .feet)
                #expect(configuration == self.sut.configuration)
            }
        }
    }

    @Test
    func maximumOperatingDepthForEAN32AtOnePointFour() async throws {
        try await given {
            let partialPressure: PartialPressure<Oxygen> = 1.4
            let blend = try Blend<Blended>.enrichedAir(0.32)
            return (partialPressure: partialPressure, blend: blend)
        } when: { input in
            try self.sut.maximumOperatingDepth(for: input.partialPressure, in: input.blend)
        } then: { _, calculation in
            try expectCalculation(calculation) { result, configuration in
                #expect(abs(result.value - 111.3749975413084) <= 0.0001)
                #expect(result.unit == .feet)
                #expect(configuration == self.sut.configuration)
            }
        }
    }

    @Test
    func maximumOperatingDepthForEAN34AtOnePointFour() async throws {
        try await given {
            let partialPressure: PartialPressure<Oxygen> = 1.4
            let blend = try Blend<Blended>.enrichedAir(0.34)
            return (partialPressure: partialPressure, blend: blend)
        } when: { input in
            try self.sut.maximumOperatingDepth(for: input.partialPressure, in: input.blend)
        } then: { _, calculation in
            try expectCalculation(calculation) { result, configuration in
                #expect(abs(result.value - 102.88235062711377) <= 0.0001)
                #expect(result.unit == .feet)
                #expect(configuration == self.sut.configuration)
            }
        }
    }

    @Test
    func maximumOperatingDepthForEAN36AtOnePointFour() async throws {
        try await given {
            let partialPressure: PartialPressure<Oxygen> = 1.4
            let blend = try Blend<Blended>.enrichedAir(0.36)
            return (partialPressure: partialPressure, blend: blend)
        } when: { input in
            try self.sut.maximumOperatingDepth(for: input.partialPressure, in: input.blend)
        } then: { _, calculation in
            try expectCalculation(calculation) { result, configuration in
                #expect(abs(result.value - 95.3333311478297) <= 0.0001)
                #expect(result.unit == .feet)
                #expect(configuration == self.sut.configuration)
            }
        }
    }

    @Test
    func maximumOperatingDepthForEAN40AtOnePointFour() async throws {
        try await given {
            let partialPressure: PartialPressure<Oxygen> = 1.4
            let blend = try Blend<Blended>.enrichedAir(0.40)
            return (partialPressure: partialPressure, blend: blend)
        } when: { input in
            try self.sut.maximumOperatingDepth(for: input.partialPressure, in: input.blend)
        } then: { _, calculation in
            try expectCalculation(calculation) { result, configuration in
                #expect(abs(result.value - 82.49999803304672) <= 0.0001)
                #expect(result.unit == .feet)
                #expect(configuration == self.sut.configuration)
            }
        }
    }

    @Test
    func maximumOperatingDepthForEAN28AtOnePointSix() async throws {
        try await given {
            let partialPressure: PartialPressure<Oxygen> = 1.6
            let blend = try Blend<Blended>.enrichedAir(0.28)
            return (partialPressure: partialPressure, blend: blend)
        } when: { input in
            try self.sut.maximumOperatingDepth(for: input.partialPressure, in: input.blend)
        } then: { _, calculation in
            try expectCalculation(calculation) { result, configuration in
                #expect(abs(result.value - 155.5714313813618) <= 0.0001)
                #expect(result.unit == .feet)
                #expect(configuration == self.sut.configuration)
            }
        }
    }

    @Test
    func maximumOperatingDepthForEAN30AtOnePointSix() async throws {
        try await given {
            let partialPressure: PartialPressure<Oxygen> = 1.6
            let blend = try Blend<Blended>.enrichedAir(0.30)
            return (partialPressure: partialPressure, blend: blend)
        } when: { input in
            try self.sut.maximumOperatingDepth(for: input.partialPressure, in: input.blend)
        } then: { _, calculation in
            try expectCalculation(calculation) { result, configuration in
                #expect(abs(result.value - 143.00000262260437) <= 0.0001)
                #expect(result.unit == .feet)
                #expect(configuration == self.sut.configuration)
            }
        }
    }

    @Test
    func maximumOperatingDepthForEAN32AtOnePointSix() async throws {
        try await given {
            let partialPressure: PartialPressure<Oxygen> = 1.6
            let blend = try Blend<Blended>.enrichedAir(0.32)
            return (partialPressure: partialPressure, blend: blend)
        } when: { input in
            try self.sut.maximumOperatingDepth(for: input.partialPressure, in: input.blend)
        } then: { _, calculation in
            try expectCalculation(calculation) { result, configuration in
                #expect(abs(result.value - 132.0000024586916) <= 0.0001)
                #expect(result.unit == .feet)
                #expect(configuration == self.sut.configuration)
            }
        }
    }

    @Test
    func maximumOperatingDepthForEAN34AtOnePointSix() async throws {
        try await given {
            let partialPressure: PartialPressure<Oxygen> = 1.6
            let blend = try Blend<Blended>.enrichedAir(0.34)
            return (partialPressure: partialPressure, blend: blend)
        } when: { input in
            try self.sut.maximumOperatingDepth(for: input.partialPressure, in: input.blend)
        } then: { _, calculation in
            try expectCalculation(calculation) { result, configuration in
                #expect(abs(result.value - 122.29411996112148) <= 0.0001)
                #expect(result.unit == .feet)
                #expect(configuration == self.sut.configuration)
            }
        }
    }

    @Test
    func maximumOperatingDepthForEAN36AtOnePointSix() async throws {
        try await given {
            let partialPressure: PartialPressure<Oxygen> = 1.6
            let blend = try Blend<Blended>.enrichedAir(0.36)
            return (partialPressure: partialPressure, blend: blend)
        } when: { input in
            try self.sut.maximumOperatingDepth(for: input.partialPressure, in: input.blend)
        } then: { _, calculation in
            try expectCalculation(calculation) { result, configuration in
                #expect(abs(result.value - 113.6666688521703) <= 0.0001)
                #expect(result.unit == .feet)
                #expect(configuration == self.sut.configuration)
            }
        }
    }

    @Test
    func maximumOperatingDepthForEAN40AtOnePointSix() async throws {
        try await given {
            let partialPressure: PartialPressure<Oxygen> = 1.6
            let blend = try Blend<Blended>.enrichedAir(0.40)
            return (partialPressure: partialPressure, blend: blend)
        } when: { input in
            try self.sut.maximumOperatingDepth(for: input.partialPressure, in: input.blend)
        } then: { _, calculation in
            try expectCalculation(calculation) { result, configuration in
                #expect(abs(result.value - 99.00000196695328) <= 0.0001)
                #expect(result.unit == .feet)
                #expect(configuration == self.sut.configuration)
            }
        }
    }

    @Test
    func maximumOperatingDepthForAirAtOnePointFour() async throws {
        try await given {
            let partialPressure: PartialPressure<Oxygen> = 1.4
            let blend = Blend<Blended>.air
            return (partialPressure: partialPressure, blend: blend)
        } when: { input in
            try self.sut.maximumOperatingDepth(for: input.partialPressure, in: input.blend)
        } then: { _, calculation in
            try expectCalculation(calculation) { result, configuration in
                #expect(abs(result.value - 186.99999999999997) <= 0.0001)
                #expect(result.unit == .feet)
                #expect(configuration == self.sut.configuration)
            }
        }
    }

    @Test
    func maximumOperatingDepthForAirAtOnePointSix() async throws {
        try await given {
            let partialPressure: PartialPressure<Oxygen> = 1.6
            let blend = Blend<Blended>.air
            return (partialPressure: partialPressure, blend: blend)
        } when: { input in
            try self.sut.maximumOperatingDepth(for: input.partialPressure, in: input.blend)
        } then: { _, calculation in
            try expectCalculation(calculation) { result, configuration in
                #expect(abs(result.value - 218.42857142857144) <= 0.0001)
                #expect(result.unit == .feet)
                #expect(configuration == self.sut.configuration)
            }
        }
    }

    @Test(.tags(.error))
    func maximumOperatingDepthRejectsNegativeOxygenPartialPressure() async throws {
        try await given {
            let partialPressure: PartialPressure<Oxygen> = -1.4
            let blend = try Blend<Blended>.enrichedAir(0.32)
            self.expectedError = .negative(partialPressure, "GasCalculator.maximumOperatingDepth(for:in:)")

            return (partialPressure: partialPressure, blend: blend)
        } when: { input in
            Result { try self.sut.maximumOperatingDepth(for: input.partialPressure, in: input.blend) }
        } then: { _, result in
            try expectThrowsError(when: result.get(), then: self.expectedError) {
                #expect($0.localizationValue == "dive.kit.error.negative.partial.pressure")
            }
        }
    }

    @Test(.tags(.error))
    func maximumOperatingDepthRejectsBlendWithZeroOxygen() async throws {
        try await given {
            let partialPressure: PartialPressure<Oxygen> = 1.4

            let blend = try Blend<Blended> { () throws(DiveKit.Error) in
                try FractionalPressure(of: .oxygen, fractionalPressure: 0.0)
                try FractionalPressure(of: .nitrogen, fractionalPressure: 1.0)
            }

            self.expectedError = .range(
                .lowerBound(0, 0),
                "GasCalculator.maximumOperatingDepth(for:in:)")
            return (partialPressure: partialPressure, blend: blend)
        } when: { input in
            Result { try self.sut.maximumOperatingDepth(for: input.partialPressure, in: input.blend) }
        } then: { _, result in
            try expectThrowsError(when: result.get(), then: self.expectedError) {
                #expect($0.localizationValue == "dive.kit.error.range.lower.bound")
            }
        }
    }

    @Test(.tags(.error))
    func maximumOperatingDepthRejectsZeroOxygenPartialPressure() async throws {
        try await given {
            let partialPressure: PartialPressure<Oxygen> = 0
            let blend = try Blend<Blended>.enrichedAir(0.32)

            self.expectedError = .range(
                .lowerBound(0, 0),
                "GasCalculator.maximumOperatingDepth(for:in:)")
            return (partialPressure: partialPressure, blend: blend)
        } when: { input in
            Result { try self.sut.maximumOperatingDepth(for: input.partialPressure, in: input.blend) }
        } then: { _, result in
            try expectThrowsError(when: result.get(), then: self.expectedError) {
                #expect($0.localizationValue == "dive.kit.error.range.lower.bound")
            }
        }
    }
}
