import Testing
@_spi(Experimental) @testable import DiveKit

@Suite("Tissue inspired pressure from a blend", .tags(.technicalDiving, .blend))
struct TissueInspiredBlendTests {
    @Test
    func defaultWaterVaporIsBuhlmannsInAtmospheres() async {
        await given {
            Tissue.alveolarWaterVapor
        } when: { waterVapor in
            waterVapor.value * 1.01325
        } then: { _, bar in
            #expect(bar.isApproximately(0.0627))
        }
    }

    @Test(arguments: [
        // 30 m and 99 ft of salt water are both 4 atmospheres absolute.
        (units: Units.metric, depth: 30.0),
        (units: Units.imperial, depth: 99.0)
    ])
    func inspiredPressureIsAmbientLessWaterVaporTimesFraction(units: Units, depth: Double) async throws {
        try await given {
            Configuration(units: units, water: .salt)
        } when: { configuration in
            (nitrogen: try Tissue.Inspired(of: .nitrogen, breathing: .air, at: .init(depth), configuration: configuration),
             dry: try Tissue.Inspired(
                of: .nitrogen,
                breathing: .air,
                at: .init(depth),
                waterVapor: .init(0),
                configuration: configuration))
        } then: { _, inspired in
            #expect(inspired.nitrogen.start.value.isApproximately((4 - 0.0627 / 1.01325) * 0.79))
            #expect(inspired.nitrogen.start == inspired.nitrogen.end)
            #expect(inspired.dry.start.value.isApproximately(4 * 0.79))
        }
    }

    @Test
    func linearSegmentUsesStartAndEndDepths() async throws {
        try await given {
            Configuration(units: .metric, water: .salt)
        } when: { configuration in
            try Tissue.Inspired(
                of: .helium,
                breathing: try .trimix(oxygen: 0.18, helium: 0.45),
                from: .init(0),
                to: .init(60),
                waterVapor: .init(0.1),
                configuration: configuration)
        } then: { _, inspired in
            #expect(inspired.start.value.isApproximately(0.9 * 0.45))
            #expect(inspired.end.value.isApproximately(6.9 * 0.45))
        }
    }

    @Test
    func gasAbsentFromBlendHasNoInspiredPressure() async throws {
        try await given {
            Configuration(units: .metric, water: .salt)
        } when: { configuration in
            try Tissue.Inspired(of: .helium, breathing: .air, at: .init(30), configuration: configuration)
        } then: { _, inspired in
            #expect(inspired.start.value == 0)
            #expect(inspired.end.value == 0)
        }
    }

    @Test
    func waterVaporAboveAmbientClampsToZero() async throws {
        try await given {
            Configuration(units: .metric, water: .salt)
        } when: { configuration in
            try Tissue.Inspired(of: .nitrogen, breathing: .air, at: .init(0), waterVapor: .init(2), configuration: configuration)
        } then: { _, inspired in
            #expect(inspired.start.value == 0)
        }
    }

    @Test(arguments: [
        (depth: -1.0, waterVapor: 0.06, expected: Error.negative(.depth(.init(-1)), Self.callSite), key: "dive.kit.error.negative.depth"),
        (
            depth: .infinity,
            waterVapor: 0.06,
            expected: Error.range(.upperBound(.infinity, .greatestFiniteMagnitude), Self.callSite),
            key: "dive.kit.error.range.upper.bound"),
        (depth: 30, waterVapor: -0.06, expected: Error.negative(.pressure(.init(-0.06)), Self.callSite), key: "dive.kit.error.negative.pressure"),
        (
            depth: 30,
            waterVapor: .infinity,
            expected: Error.range(.upperBound(.infinity, .greatestFiniteMagnitude), Self.callSite),
            key: "dive.kit.error.range.upper.bound")
    ])
    func rejectsInvalidDepthAndWaterVapor(depth: Double, waterVapor: Double, expected: Error, key: String) async throws {
        try await given {
            Configuration(units: .metric, water: .salt)
        } when: { configuration in
            try expectThrowsError(
                when: try Tissue.Inspired(
                    of: .nitrogen,
                    breathing: .air,
                    at: .init(depth),
                    waterVapor: .init(waterVapor),
                    configuration: configuration),
                then: expected) { error in
                #expect(error.localizationValue == .init(key))
            }
        }
    }

    @Test(arguments: [
        (increase: 0.0, expected: Error.Range.lowerBound(0, 0), key: "dive.kit.error.range.lower.bound"),
        (increase: -10, expected: Error.Range.lowerBound(-10, 0), key: "dive.kit.error.range.lower.bound"),
        (increase: .infinity, expected: Error.Range.upperBound(.infinity, .greatestFiniteMagnitude), key: "dive.kit.error.range.upper.bound"),
        // A valid but tiny depth per atmosphere makes the ambient pressure at 30 m infinite.
        (
            increase: .leastNonzeroMagnitude,
            expected: Error.Range.upperBound(.infinity, .greatestFiniteMagnitude),
            key: "dive.kit.error.range.upper.bound")
    ])
    func rejectsInvalidDepthPerAtmosphere(increase: Double, expected: Error.Range, key: String) async throws {
        try await given {
            Configuration(
                units: .metric,
                water: Water(weight: Water.salt.weight, pressure: { .init(increase: .init(increase, units: $0)) }))
        } when: { configuration in
            try expectThrowsError(
                when: try Tissue.Inspired(of: .nitrogen, breathing: .air, at: .init(30), configuration: configuration),
                then: .range(expected, Self.callSite)) { error in
                #expect(error.localizationValue == .init(key))
            }
        }
    }

    @Test
    func linearSegmentRejectsNegativeEndDepth() async throws {
        try await given {
            Configuration(units: .metric, water: .salt)
        } when: { configuration in
            try expectThrowsError(
                when: try Tissue.Inspired(
                    of: .nitrogen,
                    breathing: .air,
                    from: .init(30),
                    to: .init(-1),
                    configuration: configuration),
                then: .negative(.depth(.init(-1)), "Inspired<Nitrogen>.init(of:breathing:from:to:waterVapor:configuration:)")) { error in
                #expect(error.localizationValue == "dive.kit.error.negative.depth")
            }
        }
    }
}

private extension TissueInspiredBlendTests {
    static let callSite: CallSite = "Inspired<Nitrogen>.init(of:breathing:at:waterVapor:configuration:)"
}
