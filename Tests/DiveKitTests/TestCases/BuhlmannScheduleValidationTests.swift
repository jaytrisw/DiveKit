import Testing
@_spi(Experimental) @testable import DiveKit

@Suite("Bühlmann schedule validation", .tags(.technicalDiving, .buhlmann, .error))
struct BuhlmannScheduleValidationTests {
    @Test
    func gradientFactorsRejectLowAboveHigh() async throws {
        try await given {
            (low: try Buhlmann.GradientFactor(0.9), high: try Buhlmann.GradientFactor(0.8))
        } when: { factors in
            try expectThrowsError(
                when: try Buhlmann.GradientFactors(low: factors.low, high: factors.high),
                then: .range(.upperBound(0.9, 0.8), "GradientFactors.init(low:high:)")) { error in
                #expect(error.localizationValue == "dive.kit.error.range.upper.bound")
            }
        }
    }

    @Test
    func gradientFactorsAcceptEqualValues() async throws {
        try await given {
            try Buhlmann.GradientFactor(0.7)
        } when: { factor in
            try Buhlmann.GradientFactors(low: factor, high: factor)
        } then: { factor, factors in
            #expect(factors.low == factor && factors.high == factor)
        }
    }

    @Test
    func fullGradientFactorsAreOne() {
        #expect(Buhlmann.GradientFactors.full.low.value == 1)
        #expect(Buhlmann.GradientFactors.full.high.value == 1)
    }

    @Test(arguments: [
        (rate: 0.0, stopInterval: 3.0, lastStop: 3.0, expected: Error.Range.lowerBound(0, 0)),
        (rate: .infinity, stopInterval: 3.0, lastStop: 3.0, expected: .upperBound(.infinity, .greatestFiniteMagnitude)),
        (rate: 9.0, stopInterval: -3.0, lastStop: 3.0, expected: .lowerBound(-3, 0)),
        (rate: 9.0, stopInterval: .infinity, lastStop: 3.0, expected: .upperBound(.infinity, .greatestFiniteMagnitude)),
        (rate: 9.0, stopInterval: 3.0, lastStop: 0.0, expected: .lowerBound(0, 0)),
        (rate: 9.0, stopInterval: 3.0, lastStop: -.infinity, expected: .upperBound(-.infinity, .greatestFiniteMagnitude))
    ])
    func ascentRejectsInvalidValues(rate: Double, stopInterval: Double, lastStop: Double, expected: Error.Range) async throws {
        try await given {
            (rate: Rate<Depth>(rate), stopInterval: Depth(stopInterval), lastStop: Depth(lastStop))
        } when: { ascent in
            try expectThrowsError(
                when: try Buhlmann.Ascent(rate: ascent.rate, stopInterval: ascent.stopInterval, lastStop: ascent.lastStop),
                then: .range(expected, "Ascent.init(rate:stopInterval:lastStop:)"))
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
}

private extension BuhlmannScheduleValidationTests {
    static func schedule(
        of compartments: [Tissue.Compartment],
        from depth: Depth,
        switches: [Depth: Blend<Blended>] = [:],
        waterVapor: Pressure = Tissue.alveolarWaterVapor) throws -> Calculation<Buhlmann.Schedule> {
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
