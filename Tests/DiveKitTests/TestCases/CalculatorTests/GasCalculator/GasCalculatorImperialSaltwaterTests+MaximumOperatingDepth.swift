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
                #expect(result.value.isApproximately(131.99999999999997))
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
                #expect(result.value.isApproximately(121.00000000000001))
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
                #expect(result.value.isApproximately(111.375))
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
                #expect(result.value.isApproximately(102.88235294117646))
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
                #expect(result.value.isApproximately(95.33333333333333))
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
                #expect(result.value.isApproximately(82.49999999999999))
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
                #expect(result.value.isApproximately(155.57142857142858))
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
                #expect(result.value.isApproximately(143.00000000000003))
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
                #expect(result.value.isApproximately(132.0))
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
                #expect(result.value.isApproximately(122.29411764705883))
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
                #expect(result.value.isApproximately(113.66666666666667))
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
                #expect(result.value.isApproximately(99.0))
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
                #expect(result.value.isApproximately(186.99999999999997))
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
                #expect(result.value.isApproximately(218.42857142857144))
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
