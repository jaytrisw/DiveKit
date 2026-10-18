import Testing
@_spi(Experimental) @testable import DiveKit
import DiveKitTestSupport

@Suite("Bühlmann schedule validation", .tags(.technicalDiving, .buhlmann, .error))
struct BuhlmannScheduleValidationTests {
    @Test
    func gradientFactorsRejectLowAboveHigh() async throws {
        try await given {
            (low: try GradientFactor(0.9), high: try GradientFactor(0.8))
        } when: { factors in
            try expectThrowsError(
                when: try GradientFactors(low: factors.low, high: factors.high),
                then: .range(.upperBound(0.9, 0.8), "GradientFactors.init(low:high:)")) { error in
                #expect(error.localizationValue == "dive.kit.error.range.upper.bound")
            }
        }
    }

    @Test
    func gradientFactorsAcceptEqualValues() async throws {
        try await given {
            try GradientFactor(0.7)
        } when: { factor in
            try GradientFactors(low: factor, high: factor)
        } then: { factor, factors in
            #expect(factors.low == factor && factors.high == factor)
        }
    }

    @Test
    func fullGradientFactorsAreOne() {
        #expect(GradientFactors.full.low.value == 1)
        #expect(GradientFactors.full.high.value == 1)
    }

    @Test(arguments: [
        (rate: 0.0, stopInterval: 3.0, lastStop: 3.0, expected: Error.Range.lowerBound(0, 0), key: "dive.kit.error.range.lower.bound"),
        (rate: .infinity, stopInterval: 3.0, lastStop: 3.0, expected: .upperBound(.infinity, .greatestFiniteMagnitude), key: "dive.kit.error.range.upper.bound"),
        (rate: 9.0, stopInterval: -3.0, lastStop: 3.0, expected: .lowerBound(-3, 0), key: "dive.kit.error.range.lower.bound"),
        (rate: 9.0, stopInterval: .infinity, lastStop: 3.0, expected: .upperBound(.infinity, .greatestFiniteMagnitude), key: "dive.kit.error.range.upper.bound"),
        (rate: 9.0, stopInterval: 3.0, lastStop: 0.0, expected: .lowerBound(0, 0), key: "dive.kit.error.range.lower.bound"),
        (rate: 9.0, stopInterval: 3.0, lastStop: -.infinity, expected: .upperBound(-.infinity, .greatestFiniteMagnitude), key: "dive.kit.error.range.upper.bound")
    ])
    func ascentRejectsInvalidValues(rate: Double, stopInterval: Double, lastStop: Double, expected: Error.Range, key: String) async throws {
        try await given {
            (rate: Rate<Depth>(rate), stopInterval: Depth(stopInterval), lastStop: Depth(lastStop))
        } when: { ascent in
            try expectThrowsError(
                when: try AscentProfile(rate: ascent.rate, stopInterval: ascent.stopInterval, lastStop: ascent.lastStop),
                then: .range(expected, "AscentProfile.init(rate:stopInterval:lastStop:)")) { error in
                #expect(error.localizationValue == .init(key))
            }
        }
    }

    @Test
    func scheduleRejectsNegativeDepth() async throws {
        try await given {
            try Buhlmann.Table.zhl16c.compartments(nitrogen: .init(0.74))
        } when: { compartments in
            try expectThrowsError(
                when: try Self.schedule(of: compartments, from: .init(-1)),
                then: .negative(.depth(.init(-1)), BuhlmannScheduleTests.callSite)) { error in
                #expect(error.localizationValue == "dive.kit.error.negative.depth")
            }
        }
    }

    @Test
    func scheduleRejectsNegativeSwitchDepth() async throws {
        try await given {
            try Buhlmann.Table.zhl16c.compartments(nitrogen: .init(0.74))
        } when: { compartments in
            try expectThrowsError(
                when: try Self.schedule(of: compartments, from: .init(30), switches: [.init(-6): try .enrichedAir(1)]),
                then: .negative(.depth(.init(-6)), BuhlmannScheduleTests.callSite)) { error in
                #expect(error.localizationValue == "dive.kit.error.negative.depth")
            }
        }
    }

    @Test
    func scheduleRejectsInfiniteSwitchDepth() async throws {
        try await given {
            try Buhlmann.Table.zhl16c.compartments(nitrogen: .init(0.74))
        } when: { compartments in
            try expectThrowsError(
                when: try Self.schedule(of: compartments, from: .init(30), switches: [.init(.infinity): try .enrichedAir(0.5)]),
                then: .range(.upperBound(.infinity, .greatestFiniteMagnitude), BuhlmannScheduleTests.callSite)) { error in
                #expect(error.localizationValue == "dive.kit.error.range.upper.bound")
            }
        }
    }

    @Test(arguments: [
        (increase: 0.0, expected: Error.Range.lowerBound(0, 0), key: "dive.kit.error.range.lower.bound"),
        (increase: -10, expected: Error.Range.lowerBound(-10, 0), key: "dive.kit.error.range.lower.bound"),
        (increase: .infinity, expected: Error.Range.upperBound(.infinity, .greatestFiniteMagnitude), key: "dive.kit.error.range.upper.bound"),
        (increase: -.infinity, expected: Error.Range.upperBound(-.infinity, .greatestFiniteMagnitude), key: "dive.kit.error.range.upper.bound")
    ])
    func scheduleRejectsInvalidDepthPerAtmosphere(increase: Double, expected: Error.Range, key: String) async throws {
        try await given {
            (compartments: try Buhlmann.Table.zhl16c.compartments(nitrogen: .init(0.74)),
             configuration: Configuration(
                units: .metric,
                water: Water(weight: Water.salt.weight, pressure: { .init(increase: .init(increase, units: $0)) })))
        } when: { input in
            try expectThrowsError(
                when: try Buhlmann.Table.zhl16c.schedule(
                    of: input.compartments,
                    from: .init(30),
                    breathing: try .enrichedAir(0.21),
                    ascent: try .init(rate: .init(9), stopInterval: .init(3), lastStop: .init(3)),
                    configuration: input.configuration),
                then: .range(expected, BuhlmannScheduleTests.callSite)) { error in
                #expect(error.localizationValue == .init(key))
            }
        }
    }

    @Test
    func scheduleRejectsNegativeWaterVapor() async throws {
        try await given {
            try Buhlmann.Table.zhl16c.compartments(nitrogen: .init(0.74))
        } when: { compartments in
            try expectThrowsError(
                when: try Self.schedule(of: compartments, from: .init(30), waterVapor: .init(-0.1)),
                then: .negative(.pressure(.init(-0.1)), BuhlmannScheduleTests.callSite)) { error in
                #expect(error.localizationValue == "dive.kit.error.negative.pressure")
            }
        }
    }

    @Test
    func scheduleAtSurfaceRejectsOverflowingToleratedPressure() async throws {
        try await given {
            Tissue.Compartment(
                try .init(of: .nitrogen, halfTime: .init(5), tension: .init(.greatestFiniteMagnitude)),
                try .init(of: .helium, halfTime: .init(1.88), tension: .init(.greatestFiniteMagnitude)))
        } when: { compartment in
            try expectThrowsError(
                when: try Self.schedule(of: [compartment], from: .init(0)),
                then: .range(.upperBound(.infinity, .greatestFiniteMagnitude), BuhlmannScheduleTests.callSite)) { error in
                #expect(error.localizationValue == "dive.kit.error.range.upper.bound")
            }
        }
    }
}

private extension BuhlmannScheduleValidationTests {
    static func schedule(
        of compartments: [Tissue.Compartment],
        from depth: Depth,
        switches: [Depth: Blend<Blended>] = [:],
        waterVapor: Pressure = Tissue.alveolarWaterVapor) throws -> Calculation<DecompressionSchedule> {
            try Buhlmann.Table.zhl16c.schedule(
                of: compartments,
                from: depth,
                breathing: try .enrichedAir(0.21),
                switches: switches,
                ascent: try .init(rate: .init(9), stopInterval: .init(3), lastStop: .init(3)),
                waterVapor: waterVapor,
                configuration: BuhlmannScheduleTests.configuration)
        }
}
