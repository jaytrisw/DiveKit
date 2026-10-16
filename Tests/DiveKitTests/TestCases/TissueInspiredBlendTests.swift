import Testing
@_spi(Experimental) @testable import DiveKit

@Suite("Tissue inspired pressure from a blend", .tags(.technicalDiving, .blend))
struct TissueInspiredBlendTests {
    @Test
    func defaultWaterVapourIsBuhlmannsInAtmospheres() async {
        await given {
            Tissue.alveolarWaterVapour
        } when: { waterVapour in
            waterVapour.value * 1.01325
        } then: { _, bar in
            #expect(bar.isApproximately(0.0627))
        }
    }

    @Test(arguments: [
        // 30 m and 99 ft of salt water are both 4 atmospheres absolute.
        (units: Units.metric, depth: 30.0),
        (units: Units.imperial, depth: 99.0)
    ])
    func inspiredPressureIsAmbientLessWaterVapourTimesFraction(units: Units, depth: Double) async throws {
        try await given {
            Configuration(units: units, water: .salt)
        } when: { configuration in
            (nitrogen: try Tissue.Inspired(of: .nitrogen, breathing: .air, at: .init(depth), configuration: configuration),
             dry: try Tissue.Inspired(
                of: .nitrogen,
                breathing: .air,
                at: .init(depth),
                waterVapour: .init(0),
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
                waterVapour: .init(0.1),
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
    func waterVapourAboveAmbientClampsToZero() async throws {
        try await given {
            Configuration(units: .metric, water: .salt)
        } when: { configuration in
            try Tissue.Inspired(of: .nitrogen, breathing: .air, at: .init(0), waterVapour: .init(2), configuration: configuration)
        } then: { _, inspired in
            #expect(inspired.start.value == 0)
        }
    }

    @Test(arguments: [
        (depth: -1.0, waterVapour: 0.06, expected: Error.negative(.depth(.init(-1)), Self.callSite), key: "dive.kit.error.negative.depth"),
        (
            depth: .infinity,
            waterVapour: 0.06,
            expected: Error.range(.upperBound(.infinity, .greatestFiniteMagnitude), Self.callSite),
            key: "dive.kit.error.range.upper.bound"),
        (depth: 30, waterVapour: -0.06, expected: Error.negative(.pressure(.init(-0.06)), Self.callSite), key: "dive.kit.error.negative.pressure"),
        (
            depth: 30,
            waterVapour: .infinity,
            expected: Error.range(.upperBound(.infinity, .greatestFiniteMagnitude), Self.callSite),
            key: "dive.kit.error.range.upper.bound")
    ])
    func rejectsInvalidDepthAndWaterVapour(depth: Double, waterVapour: Double, expected: Error, key: String) async throws {
        try await given {
            Configuration(units: .metric, water: .salt)
        } when: { configuration in
            try expectThrowsError(
                when: try Tissue.Inspired(
                    of: .nitrogen,
                    breathing: .air,
                    at: .init(depth),
                    waterVapour: .init(waterVapour),
                    configuration: configuration),
                then: expected) { error in
                #expect(error.localizationValue == .init(key))
            }
        }
    }
}

private extension TissueInspiredBlendTests {
    static let callSite: CallSite = "Inspired<Nitrogen>.init(of:breathing:from:to:waterVapour:configuration:)"
}
