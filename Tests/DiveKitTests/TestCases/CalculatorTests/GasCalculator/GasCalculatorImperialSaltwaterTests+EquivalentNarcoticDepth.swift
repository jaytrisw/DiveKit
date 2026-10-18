import Testing
@_spi(Experimental) @testable import DiveKit
@_spi(Experimental) import DiveKitTestSupport

extension GasCalculatorImperialSaltwaterTests {

    // MARK: equivalentNarcoticDepth(for:with:treating:)

    /// Standard END, nitrogen only: (165 + 33) × 0.37 / 0.79 − 33 = 59.7341772151898734… ft.
    @Test(.tags(.technicalDiving))
    func equivalentNarcoticDepthValidInput() async throws {
        try await given {
            let depth: Depth = 165.0
            let blend = try Blend<Blended>.trimix(oxygen: 0.18, helium: 0.45)
            return (depth: depth, blend: blend)
        } when: { input in
            try self.sut.equivalentNarcoticDepth(for: input.depth, with: input.blend)
        } then: { _, calculation in
            try expectCalculation(calculation) { result, configuration in
                #expect(result.value.isApproximately(59.734177215189874))
                #expect(result.unit == .feet)
                #expect(configuration == self.sut.configuration)
            }
        }
    }

    /// Oxygen as narcotic as nitrogen: (165 + 33) × (0.37 + 0.18) / (0.79 + 0.21) − 33 = 75.9 ft.
    @Test(.tags(.technicalDiving))
    func equivalentNarcoticDepthWithNarcoticOxygen() async throws {
        try await given {
            let depth: Depth = 165.0
            let blend = try Blend<Blended>.trimix(oxygen: 0.18, helium: 0.45)
            return (depth: depth, blend: blend)
        } when: { input in
            try self.sut.equivalentNarcoticDepth(for: input.depth, with: input.blend, treating: .narcotic(.oxygen))
        } then: { _, calculation in
            try expectCalculation(calculation) { result, _ in
                #expect(result.value.isApproximately(75.9))
                #expect(result.unit == .feet)
            }
        }
    }

    /// Bennett and Rostain (2003) helium potency 0.2:
    /// (165 + 33) * (0.37 + 0.2 * 0.45) / 0.79 - 33 = 82.29113924050632… ft, by exact decimal arithmetic.
    @Test(.tags(.technicalDiving))
    func equivalentNarcoticDepthWithBennettHelium() async throws {
        try await given {
            let depth: Depth = 165.0
            let blend = try Blend<Blended>.trimix(oxygen: 0.18, helium: 0.45)
            return (depth: depth, blend: blend)
        } when: { input in
            try self.sut.equivalentNarcoticDepth(for: input.depth, with: input.blend, treating: .bennett(.helium))
        } then: { _, calculation in
            try expectCalculation(calculation) { result, _ in
                #expect(result.value.isApproximately(82.29113924050633))
            }
        }
    }

    /// Bennett and Rostain (2003) oxygen potency 1.7:
    /// (165 + 33) × (0.37 + 1.7 × 0.18) / (0.79 + 1.7 × 0.21) − 33 = 83.6939843068875326… ft.
    @Test(.tags(.technicalDiving))
    func equivalentNarcoticDepthWithBennettOxygen() async throws {
        try await given {
            let depth: Depth = 165.0
            let blend = try Blend<Blended>.trimix(oxygen: 0.18, helium: 0.45)
            return (depth: depth, blend: blend)
        } when: { input in
            try self.sut.equivalentNarcoticDepth(for: input.depth, with: input.blend, treating: .bennett(.oxygen))
        } then: { _, calculation in
            try expectCalculation(calculation) { result, _ in
                #expect(result.value.isApproximately(83.69398430688754))
            }
        }
    }

    @Test(.tags(.technicalDiving), arguments: [0.0, 33.0, 100.0, 330.0])
    func equivalentNarcoticDepthAirEqualsActualDepth(depth: Depth) async throws {
        try await given {
            (depth: depth, blend: Blend<Blended>.air)
        } when: { input in
            (oxygenNotNarcotic: try self.sut.equivalentNarcoticDepth(for: input.depth, with: input.blend),
             oxygenNarcotic: try self.sut.equivalentNarcoticDepth(
                for: input.depth,
                with: input.blend,
                treating: .narcotic(.oxygen)),
             bennett: try self.sut.equivalentNarcoticDepth(
                for: input.depth,
                with: input.blend,
                treating: .bennett(.oxygen), .bennett(.helium)))
        } then: { input, calculations in
            #expect(calculations.oxygenNotNarcotic.result.value.isApproximately(input.depth.value))
            #expect(calculations.oxygenNarcotic.result.value.isApproximately(input.depth.value))
            #expect(calculations.bennett.result.value.isApproximately(input.depth.value))
        }
    }

    @Test(.tags(.technicalDiving))
    func equivalentNarcoticDepthCustomGasUsesDeclaredPotency() async throws {
        try await given {
            let depth: Depth = 165.0
            let blend = Blend<Blended>((Oxygen(), 0.21), (Neon(), 0.79))
            return (depth: depth, blend: blend)
        } when: { input in
            try self.sut.equivalentNarcoticDepth(for: input.depth, with: input.blend)
        } then: { _, calculation in
            try expectCalculation(calculation) { result, _ in
                #expect(result.value.isApproximately(26.4))
            }
        }
    }

    @Test(.tags(.technicalDiving))
    func equivalentNarcoticDepthIgnoresOverrideForAbsentGas() async throws {
        try await given {
            let depth: Depth = 165.0
            let blend = try Blend<Blended>.trimix(oxygen: 0.18, helium: 0.45)
            return (depth: depth, blend: blend)
        } when: { input in
            (plain: try self.sut.equivalentNarcoticDepth(for: input.depth, with: input.blend),
             overridden: try self.sut.equivalentNarcoticDepth(
                for: input.depth,
                with: input.blend,
                treating: .narcotic(Neon(), potency: .relative(5))))
        } then: { _, calculations in
            #expect(calculations.overridden.result == calculations.plain.result)
        }
    }

    @Test(.tags(.technicalDiving))
    func equivalentNarcoticDepthLastDuplicateOverrideWins() async throws {
        try await given {
            let depth: Depth = 165.0
            let blend = try Blend<Blended>.trimix(oxygen: 0.18, helium: 0.45)
            return (depth: depth, blend: blend)
        } when: { input in
            (single: try self.sut.equivalentNarcoticDepth(
                for: input.depth,
                with: input.blend,
                treating: .narcotic(.oxygen)),
             duplicated: try self.sut.equivalentNarcoticDepth(
                for: input.depth,
                with: input.blend,
                treating: .narcotic(.oxygen, potency: .relative(5)), .narcotic(.oxygen)))
        } then: { _, calculations in
            #expect(calculations.duplicated.result == calculations.single.result)
        }
    }

    @Test(.tags(.technicalDiving))
    func equivalentNarcoticDepthUnblendedValidInput() async throws {
        try await given {
            let depth: Depth = 165.0
            let blend = try Blend<Unblended>()
                .adding(.oxygen, pressure: 0.18)
                .adding(.helium, pressure: 0.45)
                .filling(with: .nitrogen)
            return (depth: depth, blend: blend)
        } when: { input in
            try self.sut.equivalentNarcoticDepth(for: input.depth, with: input.blend, treating: .narcotic(.oxygen))
        } then: { _, calculation in
            try expectCalculation(calculation) { result, configuration in
                #expect(result.value.isApproximately(75.9))
                #expect(result.unit == .feet)
                #expect(configuration == self.sut.configuration)
            }
        }
    }

    @Test(.tags(.error, .technicalDiving))
    func equivalentNarcoticDepthInvalidDepthInput() async throws {
        try await given {
            let depth: Depth = -165.0
            let blend = try Blend<Blended>.trimix(oxygen: 0.18, helium: 0.45)
            let expectedError: Error = .negative(depth, "GasCalculator.equivalentNarcoticDepth(for:with:treating:)")
            return (depth: depth, blend: blend, expectedError: expectedError)
        } when: { input in
            Result { try self.sut.equivalentNarcoticDepth(for: input.depth, with: input.blend) }
        } then: { input, result in
            try expectThrowsError(when: result.get(), then: input.expectedError) {
                #expect($0.localizationValue == "dive.kit.error.negative.depth")
            }
        }
    }

    @Test(.tags(.error, .technicalDiving))
    func equivalentNarcoticDepthNegativePotencyInput() async throws {
        try await given {
            let depth: Depth = 165.0
            let blend = try Blend<Blended>.trimix(oxygen: 0.18, helium: 0.45)
            let expectedError: Error = .range(.lowerBound(-1, 0), "GasCalculator.equivalentNarcoticDepth(for:with:treating:)")
            return (depth: depth, blend: blend, expectedError: expectedError)
        } when: { input in
            Result {
                try self.sut.equivalentNarcoticDepth(
                    for: input.depth,
                    with: input.blend,
                    treating: .narcotic(.oxygen, potency: .relative(-1)))
            }
        } then: { input, result in
            try expectThrowsError(when: result.get(), then: input.expectedError) {
                #expect($0.localizationValue == "dive.kit.error.range.lower.bound")
            }
        }
    }

    @Test(.tags(.error, .technicalDiving))
    func equivalentNarcoticDepthNonFinitePotencyInput() async throws {
        try await given {
            let depth: Depth = 165.0
            let blend = try Blend<Blended>.trimix(oxygen: 0.18, helium: 0.45)
            let expectedError: Error = .range(
                .upperBound(.infinity, .greatestFiniteMagnitude),
                "GasCalculator.equivalentNarcoticDepth(for:with:treating:)")
            return (depth: depth, blend: blend, expectedError: expectedError)
        } when: { input in
            Result {
                try self.sut.equivalentNarcoticDepth(
                    for: input.depth,
                    with: input.blend,
                    treating: .narcotic(.oxygen, potency: .relative(.infinity)))
            }
        } then: { input, result in
            try expectThrowsError(when: result.get(), then: input.expectedError) {
                #expect($0.localizationValue == "dive.kit.error.range.upper.bound")
            }
        }
    }

    @Test(.tags(.error, .technicalDiving))
    func equivalentNarcoticDepthInvalidDeclaredPotencyInput() async throws {
        try await given {
            let depth: Depth = 165.0
            let blend = Blend<Blended>((Oxygen(), 0.21), (InvalidPotencyGas(), 0.79))
            let expectedError: Error = .range(.lowerBound(-1, 0), "GasCalculator.equivalentNarcoticDepth(for:with:treating:)")
            return (depth: depth, blend: blend, expectedError: expectedError)
        } when: { input in
            Result { try self.sut.equivalentNarcoticDepth(for: input.depth, with: input.blend) }
        } then: { input, result in
            try expectThrowsError(when: result.get(), then: input.expectedError) {
                #expect($0.localizationValue == "dive.kit.error.range.lower.bound")
            }
        }
    }

    @Test(.tags(.technicalDiving))
    func equivalentNarcoticDepthOverrideReplacesInvalidDeclaredPotency() async throws {
        try await given {
            let depth: Depth = 165.0
            let blend = Blend<Blended>((Oxygen(), 0.21), (InvalidPotencyGas(), 0.79))
            return (depth: depth, blend: blend)
        } when: { input in
            try self.sut.equivalentNarcoticDepth(
                for: input.depth,
                with: input.blend,
                treating: .narcotic(InvalidPotencyGas()))
        } then: { _, calculation in
            #expect(calculation.result.value.isApproximately(165))
        }
    }

    @Test(.tags(.error, .technicalDiving))
    func equivalentNarcoticDepthNonNarcoticAirInput() async throws {
        try await given {
            let depth: Depth = 165.0
            let blend = try Blend<Blended>.trimix(oxygen: 0.18, helium: 0.45)
            let expectedError: Error = .range(.lowerBound(0, 0), "GasCalculator.equivalentNarcoticDepth(for:with:treating:)")
            return (depth: depth, blend: blend, expectedError: expectedError)
        } when: { input in
            Result {
                try self.sut.equivalentNarcoticDepth(
                    for: input.depth,
                    with: input.blend,
                    treating: .narcotic(.nitrogen, potency: .relative(0)))
            }
        } then: { input, result in
            try expectThrowsError(when: result.get(), then: input.expectedError) {
                #expect($0.localizationValue == "dive.kit.error.range.lower.bound")
            }
        }
    }

    @Test(.tags(.error, .technicalDiving))
    func equivalentNarcoticDepthOverflowingRatioInput() async throws {
        try await given {
            let depth: Depth = 165.0
            let blend = Blend<Blended>((Oxygen(), 0.21), (Neon(), 0.79))
            let expectedError: Error = .range(
                .upperBound(.infinity, .greatestFiniteMagnitude),
                "GasCalculator.equivalentNarcoticDepth(for:with:treating:)")
            return (depth: depth, blend: blend, expectedError: expectedError)
        } when: { input in
            Result {
                try self.sut.equivalentNarcoticDepth(
                    for: input.depth,
                    with: input.blend,
                    treating: .narcotic(.nitrogen, potency: .relative(.leastNonzeroMagnitude)))
            }
        } then: { input, result in
            try expectThrowsError(when: result.get(), then: input.expectedError) {
                #expect($0.localizationValue == "dive.kit.error.range.upper.bound")
            }
        }
    }

    @Test(.tags(.error, .technicalDiving))
    func equivalentNarcoticDepthUnblendedInvalidBlendInput() async throws {
        try await given {
            let depth: Depth = 165.0
            let fractionalPressure = 0.18
            let blend = try Blend<Unblended>(.init(of: .oxygen, fractionalPressure: fractionalPressure))
            let expectedError: Error = .blend(
                .totalPressure(fractionalPressure, blend),
                "GasCalculator.equivalentNarcoticDepth(for:with:treating:)")
            return (depth: depth, blend: blend, expectedError: expectedError)
        } when: { input in
            Result { try self.sut.equivalentNarcoticDepth(for: input.depth, with: input.blend) }
        } then: { input, result in
            try expectThrowsError(when: result.get(), then: input.expectedError) {
                #expect($0.localizationValue == "dive.kit.error.blend.total.pressure")
            }
        }
    }
}

/// A gas that declares a negative narcotic potency.
private struct InvalidPotencyGas: GasRepresentable {
    var metabolism: Metabolism { .inert }
    var narcoticPotency: NarcoticPotency { .relative(-1) }
}
