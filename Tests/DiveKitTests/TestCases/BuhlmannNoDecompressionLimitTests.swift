import Testing
@_spi(Experimental) @testable import DiveKit
import DiveKitTestSupport

@Suite("Bühlmann no-decompression limit", .tags(.technicalDiving, .buhlmann))
struct BuhlmannNoDecompressionLimitTests {
    @Test(arguments: [
        // Expected values are from Tests/Reference/BuhlmannReference.swift (38-digit Decimal),
        // compared within the standard 1e-12 tolerance.
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
    func untrackedBlendGasIsIgnored() async throws {
        // Both blends are 44% nitrogen, and a nitrogen-only compartment ignores the trimix's helium.
        try await given {
            [Tissue.Compartment(try .init(of: .nitrogen, halfTime: .init(54.3), tension: .init(0.74)))]
        } when: { compartments in
            try [Blend.trimix(oxygen: 0.21, helium: 0.35), .enrichedAir(0.56)].map {
                try Buhlmann.Table.zhl16c.noDecompressionLimit(
                    of: compartments,
                    at: .init(40),
                    breathing: $0,
                    configuration: Self.configuration)
            }
        } then: { _, limits in
            guard case .minutes = limits[1] else {
                Issue.record("Expected a limit in minutes, got \(limits[1]).")
                return
            }
            #expect(limits[0] == limits[1])
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
    func laterTransientCounterDiffusionCeilingEndsLimit() async throws {
        // The compartment tolerates the surface at every whole minute through 4, but a
        // ceiling forms and clears inside minute 4.
        try await given {
            [try Buhlmann.Table.zhl16c.compartments(nitrogen: .init(2.508))[0]]
        } when: { compartments in
            try Buhlmann.Table.zhl16c.noDecompressionLimit(
                of: compartments,
                at: .init(21.5),
                breathing: try .trimix(oxygen: 0.2, helium: 0.8),
                configuration: Self.configuration)
        } then: { _, limit in
            #expect(limit == .minutes(.init(3)))
        }
    }

    @Test
    func counterDiffusionWithoutCeilingIsUnlimited() async throws {
        // Nitrogen off-gasses while helium on-gasses, but no ceiling ever forms.
        try await given {
            [try Buhlmann.Table.zhl16c.compartments(nitrogen: .init(0.74))[0]]
        } when: { compartments in
            try Buhlmann.Table.zhl16c.noDecompressionLimit(
                of: compartments,
                at: .init(3),
                breathing: try .trimix(oxygen: 0.21, helium: 0.79),
                configuration: Self.configuration)
        } then: { _, limit in
            #expect(limit == .unlimited)
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
    func withoutWaterVaporLimitIsShorter() async throws {
        try await given {
            try Buhlmann.Table.zhl16c.compartments(nitrogen: .init(0.74))
        } when: { compartments in
            try Buhlmann.Table.zhl16c.noDecompressionLimit(
                of: compartments,
                at: .init(30),
                breathing: .air,
                waterVapor: .init(0),
                configuration: Self.configuration)
        } then: { _, limit in
            #expect(limit == .minutes(.init(15)))
        }
    }

    @Test
    func loadingModelIsUsed() async throws {
        // Every compartment reaches the inspired pressure at once, so a ceiling forms in the first minute.
        try await given {
            try Buhlmann.Table.zhl16c.compartments(nitrogen: .init(0.74))
        } when: { compartments in
            try Buhlmann.Table.zhl16c.noDecompressionLimit(
                of: compartments,
                at: .init(30),
                breathing: .air,
                configuration: Self.configuration,
                using: Tissue.Loading { _, inspired, _, _ in inspired.to })
        } then: { _, limit in
            #expect(limit == .minutes(.init(0)))
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
                    "Table.noDecompressionLimit(of:at:breathing:gradientFactor:waterVapor:configuration:using:)")) { error in
                #expect(error.localizationValue == "dive.kit.error.gas.unmodeled")
            }
        }
    }

    @Test
    func rejectsOverflowingToleratedPressure() async throws {
        // Each tension is finite, but their sum and the tolerated pressure are not.
        try await given {
            Tissue.Compartment(
                try .init(of: .nitrogen, halfTime: .init(5), tension: .init(.greatestFiniteMagnitude)),
                try .init(of: .helium, halfTime: .init(1.88), tension: .init(.greatestFiniteMagnitude)))
        } when: { compartment in
            try expectThrowsError(
                when: try Buhlmann.Table.zhl16c.noDecompressionLimit(
                    of: [compartment],
                    at: .init(30),
                    breathing: .air,
                    configuration: Self.configuration),
                then: .range(
                    .upperBound(.infinity, .greatestFiniteMagnitude),
                    "Table.noDecompressionLimit(of:at:breathing:gradientFactor:waterVapor:configuration:using:)")) { error in
                #expect(error.localizationValue == "dive.kit.error.range.upper.bound")
            }
        }
    }

    @Test
    func rejectsNegativeModelResult() async throws {
        try await given {
            try Buhlmann.Table.zhl16c.compartments(nitrogen: .init(0.74))
        } when: { compartments in
            try expectThrowsError(
                when: try Buhlmann.Table.zhl16c.noDecompressionLimit(
                    of: compartments,
                    at: .init(30),
                    breathing: .air,
                    configuration: Self.configuration,
                    using: Tissue.Loading { _, _, _, _ in -1 }),
                then: .negative(
                    .partialPressure(-1),
                    "Table.noDecompressionLimit(of:at:breathing:gradientFactor:waterVapor:configuration:using:)")) { error in
                #expect(error.localizationValue == "dive.kit.error.negative.partial.pressure")
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
                    "Table.noDecompressionLimit(of:at:breathing:gradientFactor:waterVapor:configuration:using:)")) { error in
                #expect(error.localizationValue == "dive.kit.error.negative.depth")
            }
        }
    }

    @Test(arguments: [
        (increase: 0.0, expected: Error.Range.lowerBound(0, 0), key: "dive.kit.error.range.lower.bound"),
        (increase: -10, expected: Error.Range.lowerBound(-10, 0), key: "dive.kit.error.range.lower.bound"),
        (increase: .infinity, expected: Error.Range.upperBound(.infinity, .greatestFiniteMagnitude), key: "dive.kit.error.range.upper.bound"),
        (increase: -.infinity, expected: Error.Range.upperBound(-.infinity, .greatestFiniteMagnitude), key: "dive.kit.error.range.upper.bound")
    ])
    func rejectsInvalidDepthPerAtmosphere(increase: Double, expected: Error.Range, key: String) async throws {
        try await given {
            (compartments: try Buhlmann.Table.zhl16c.compartments(nitrogen: .init(0.74)),
             configuration: Configuration(
                units: .metric,
                water: Water(weight: Water.salt.weight, pressure: { .init(increase: .init(increase, units: $0)) })))
        } when: { input in
            try expectThrowsError(
                when: try Buhlmann.Table.zhl16c.noDecompressionLimit(
                    of: input.compartments,
                    at: .init(30),
                    breathing: .air,
                    configuration: input.configuration),
                then: .range(
                    expected,
                    "Table.noDecompressionLimit(of:at:breathing:gradientFactor:waterVapor:configuration:using:)")) { error in
                #expect(error.localizationValue == .init(key))
            }
        }
    }
}

private extension BuhlmannNoDecompressionLimitTests {
    static let configuration = Configuration(units: .metric, water: .salt)
}
