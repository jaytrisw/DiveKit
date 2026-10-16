import Testing
@_spi(Experimental) @testable import DiveKit

@Suite("Bühlmann no-decompression limit", .tags(.technicalDiving, .buhlmann))
struct BuhlmannNoDecompressionLimitTests {
    @Test(arguments: [
        // Expected values were calculated separately with 50-digit decimal arithmetic.
        // Air's trace gases are untracked, so it is modeled as 79% nitrogen.
        (depth: 30.0, oxygen: 0.21, helium: 0.0, gradientFactor: 1.0, minutes: 16.0),
        (depth: 18.0, oxygen: 0.21, helium: 0.0, gradientFactor: 1.0, minutes: 58.0),
        (depth: 30.0, oxygen: 0.32, helium: 0.0, gradientFactor: 0.85, minutes: 18.0),
        (depth: 40.0, oxygen: 0.18, helium: 0.45, gradientFactor: 1.0, minutes: 6.0)
    ])
    func squareProfileMatchesIndependentCalculation(
        depth: Double,
        oxygen: Double,
        helium: Double,
        gradientFactor: Double,
        minutes: Double) async throws {
            try await given {
                try Buhlmann.Table.zhl16c.compartments(nitrogen: .init(0.74))
            } when: { compartments in
                try Buhlmann.Table.zhl16c.noDecompressionLimit(
                    of: compartments,
                    at: .init(depth),
                    breathing: try .trimix(oxygen: oxygen, helium: helium),
                    gradientFactor: try .init(gradientFactor),
                    configuration: Self.configuration)
            } then: { _, limit in
                #expect(limit == .minutes(.init(minutes)))
            }
        }

    @Test
    func untrackedTraceGasIsIgnored() async throws {
        try await given {
            try Buhlmann.Table.zhl16c.compartments(nitrogen: .init(0.74))
        } when: { compartments in
            try Buhlmann.Table.zhl16c.noDecompressionLimit(
                of: compartments,
                at: .init(30),
                breathing: .air,
                configuration: Self.configuration)
        } then: { _, limit in
            #expect(limit == .minutes(.init(16)))
        }
    }

    @Test
    func transientCounterDiffusionCeilingEndsLimit() async throws {
        // Nitrogen off-gasses while helium on-gasses; the ceiling is above the surface
        // from about 0.37 to 0.63 minutes, then clears, so whole-minute checks miss it.
        try await given {
            [try Buhlmann.Table.zhl16c.compartments(nitrogen: .init(2.937))[0]]
        } when: { compartments in
            try Buhlmann.Table.zhl16c.noDecompressionLimit(
                of: compartments,
                at: .init(10.75),
                breathing: try .trimix(oxygen: 0.2, helium: 0.8),
                configuration: Self.configuration)
        } then: { _, limit in
            #expect(limit == .minutes(.init(0)))
        }
    }

    @Test
    func shallowDepthIsUnlimited() async throws {
        try await given {
            try Buhlmann.Table.zhl16c.compartments(nitrogen: .init(0.74))
        } when: { compartments in
            try Buhlmann.Table.zhl16c.noDecompressionLimit(
                of: compartments,
                at: .init(3),
                breathing: .air,
                configuration: Self.configuration)
        } then: { _, limit in
            #expect(limit == .unlimited)
        }
    }

    @Test
    func existingCeilingIsExceeded() async throws {
        try await given {
            try Buhlmann.Table.zhl16c.compartments(nitrogen: .init(3))
        } when: { compartments in
            try Buhlmann.Table.zhl16c.noDecompressionLimit(
                of: compartments,
                at: .init(3),
                breathing: .air,
                configuration: Self.configuration)
        } then: { _, limit in
            #expect(limit == .exceeded)
        }
    }

    @Test
    func lowerGradientFactorShortensLimit() async throws {
        try await given {
            try Buhlmann.Table.zhl16c.compartments(nitrogen: .init(0.74))
        } when: { compartments in
            (full: try Buhlmann.Table.zhl16c.noDecompressionLimit(
                of: compartments,
                at: .init(30),
                breathing: .air,
                configuration: Self.configuration),
             conservative: try Buhlmann.Table.zhl16c.noDecompressionLimit(
                of: compartments,
                at: .init(30),
                breathing: .air,
                gradientFactor: try .init(0.7),
                configuration: Self.configuration))
        } then: { _, limit in
            guard case let .minutes(full) = limit.full, case let .minutes(conservative) = limit.conservative else {
                Issue.record("Expected both limits in minutes, got \(limit).")
                return
            }
            #expect(conservative.value < full.value)
        }
    }

    @Test
    func limitDoesNotDependOnCompartmentOrder() async throws {
        try await given {
            try Buhlmann.Table.zhl16c.compartments(nitrogen: .init(0.74))
        } when: { compartments in
            (inOrder: try Buhlmann.Table.zhl16c.noDecompressionLimit(
                of: compartments,
                at: .init(30),
                breathing: .air,
                configuration: Self.configuration),
             reversed: try Buhlmann.Table.zhl16c.noDecompressionLimit(
                of: compartments.reversed(),
                at: .init(30),
                breathing: .air,
                configuration: Self.configuration))
        } then: { _, limit in
            #expect(limit.inOrder == limit.reversed)
        }
    }

    @Test(arguments: [false, true])
    func unmodeledGasThrowsEvenAfterAnExistingCeiling(reversed: Bool) async throws {
        try await given {
            let compartments = [
                try Buhlmann.Table.zhl16c.compartments(nitrogen: .init(3))[0],
                Tissue.Compartment(try .init(of: .helium, halfTime: .init(4), tension: .init(0.1)))
            ]
            return reversed ? compartments.reversed() : compartments
        } when: { compartments in
            try expectThrowsError(
                when: try Buhlmann.Table.zhl16c.noDecompressionLimit(
                    of: compartments,
                    at: .init(3),
                    breathing: .air,
                    configuration: Self.configuration),
                then: .gas(
                    .unmodeled(Helium.helium),
                    "Table.noDecompressionLimit(of:at:breathing:gradientFactor:waterVapour:configuration:using:)")) { error in
                #expect(error.localizationValue == "dive.kit.error.gas.unmodeled")
            }
        }
    }

    @Test
    func rejectsNegativeDepth() async throws {
        try await given {
            try Buhlmann.Table.zhl16c.compartments(nitrogen: .init(0.74))
        } when: { compartments in
            try expectThrowsError(
                when: try Buhlmann.Table.zhl16c.noDecompressionLimit(
                    of: compartments,
                    at: .init(-1),
                    breathing: .air,
                    configuration: Self.configuration),
                then: .negative(
                    .depth(.init(-1)),
                    "Table.noDecompressionLimit(of:at:breathing:gradientFactor:waterVapour:configuration:using:)")) { error in
                #expect(error.localizationValue == "dive.kit.error.negative.depth")
            }
        }
    }
}

private extension BuhlmannNoDecompressionLimitTests {
    static let configuration = Configuration(units: .metric, water: .salt)
}
