import Testing
@_spi(Experimental) @testable import DiveKit
import DiveKitTestSupport

@Suite("Bühlmann calculator", .tags(.technicalDiving, .buhlmann, .buhlmannCalculator))
struct BuhlmannCalculatorTests {
    @Test
    func metricDefaults() {
        let settings = BuhlmannCalculator(.metric, water: .salt).settings
        #expect(settings.table == .zhl16c)
        #expect(settings.gradientFactors == .full)
        #expect(settings.ascent.rate.value == 9)
        #expect(settings.ascent.stopInterval.value == 3)
        #expect(settings.ascent.lastStop.value == 3)
        #expect(settings.waterVapor == Tissue.alveolarWaterVapor)
        #expect(settings.switchPartialPressure.value == 1.6)
    }

    @Test
    func imperialDefaults() {
        let settings = BuhlmannCalculator(.imperial, water: .salt).settings
        #expect(settings.ascent.rate.value == 30)
        #expect(settings.ascent.stopInterval.value == 10)
        #expect(settings.ascent.lastStop.value == 10)
        #expect(settings == .defaults(for: .imperial))
    }

    @Test
    func surfaceTissuesAreSaturatedOnAir() async throws {
        try await given {
            BuhlmannCalculator(.metric, water: .salt)
        } when: { calculator in
            try calculator.surfaceTissues()
        } then: { _, tissues in
            let nitrogen = (1 - Tissue.alveolarWaterVapor.value) * 0.79
            #expect(tissues.table == .zhl16c)
            let expected = try Buhlmann.Table.zhl16c.compartments(nitrogen: .init(nitrogen))
            #expect(tissues.compartments == expected)
        }
    }

    @Test
    func loadingMatchesThePublicLoadingPath() async throws {
        try await given {
            let trimix = try Blend.trimix(oxygen: 0.21, helium: 0.35)
            return [
                try DiveSegment(start: .init(0), end: .init(40), duration: .init(4), blend: trimix),
                try DiveSegment(start: .init(40), end: .init(40), duration: .init(20), blend: trimix),
                try DiveSegment(start: .init(40), end: .init(21), duration: .init(1.9), blend: trimix)
            ]
        } when: { profile in
            let calculator = try Self.calculator
            return try calculator.loaded(try calculator.surfaceTissues(), through: profile)
        } then: { profile, tissues in
            var expected = try Self.calculator.surfaceTissues().compartments
            for segment in profile {
                expected = try BuhlmannScheduleTests.loaded(expected, over: segment, for: segment.duration.value)
            }
            #expect(tissues.compartments == expected)
            #expect(tissues.table == .zhl16c)
        }
    }

    @Test
    func scheduleSegmentsReloadThroughTheCalculator() async throws {
        try await given { () throws -> (tissues: BuhlmannCalculator.Tissues, schedule: DecompressionSchedule) in
            let tissues = try Self.tissues(breathing: .air, at: 40, for: 30)
            return (tissues, try Self.calculator.schedule(of: tissues, from: .init(40), breathing: .air, switchingTo: []).result)
        } when: { sut in
            try Self.calculator.loaded(sut.tissues, through: sut.schedule.segments)
        } then: { sut, surfaced in
            var expected = sut.tissues.compartments
            for segment in sut.schedule.segments {
                expected = try BuhlmannScheduleTests.loaded(expected, over: segment, for: segment.duration.value)
            }
            #expect(surfaced.compartments == expected)

            // The last stop ends once the tissues tolerate the surface at GF high, and not a minute sooner.
            let lastStop = try #require(sut.schedule.segments.dropLast().last)
            try #require(lastStop.start == lastStop.end && lastStop.duration.value >= 2)
            var highOnly = try Self.calculator.settings
            highOnly.gradientFactors = try .init(low: try .init(0.85), high: try .init(0.85))
            let high = BuhlmannCalculator(configuration: Self.configuration, settings: highOnly)
            let stopped = try Self.calculator.loaded(sut.tissues, through: sut.schedule.segments.dropLast())
            let shortened = try Self.calculator.loaded(
                sut.tissues,
                through: sut.schedule.segments.dropLast(2) + [
                    .init(unchecked: lastStop.start, end: lastStop.end, duration: .init(lastStop.duration.value - 1), blend: lastStop.blend)
                ])
            let ceilings = (stopped: try high.ceiling(of: stopped).result.value, shortened: try high.ceiling(of: shortened).result.value)
            #expect(ceilings.stopped == 0)
            #expect(ceilings.shortened > 0)
        }
    }

    @Test
    func emptyProfileLeavesTissuesUnchanged() throws {
        let tissues = try Self.calculator.surfaceTissues()
        let loaded = try Self.calculator.loaded(tissues, through: [])
        #expect(loaded == tissues)
    }

    @Test
    func ceilingUsesLowGradientFactor() async throws {
        try await given {
            try Self.tissues(breathing: .air, at: 40, for: 30)
        } when: { tissues in
            try Self.calculator.ceiling(of: tissues)
        } then: { tissues, ceiling in
            let expected = try Buhlmann.Table.zhl16c.ceiling(
                of: tissues.compartments,
                gradientFactor: try .init(0.3),
                configuration: Self.configuration)
            #expect(ceiling == expected)
            #expect(ceiling.result.value > 0)
        }
    }

    @Test
    func ceilingAtLowGradientFactorCanFormWithinTheNoDecompressionLimit() async throws {
        try await given {
            try Self.tissues(breathing: .air, at: 30, for: 6)
        } when: { tissues in
            (ceiling: try Self.calculator.ceiling(of: tissues).result.value,
             limit: try Self.calculator.noDecompressionLimit(of: tissues, at: .init(30), breathing: .air).result,
             schedule: try Self.calculator.schedule(of: tissues, from: .init(30), breathing: .air, switchingTo: []).result)
        } then: { _, result in
            #expect(result.ceiling > 0)
            #expect(result.limit == .minutes(.init(4)))
            #expect(result.schedule.segments.count == 1)
        }
    }

    @Test
    func noDecompressionLimitUsesHighGradientFactor() async throws {
        try await given {
            try Self.calculator.surfaceTissues()
        } when: { tissues in
            try Self.calculator.noDecompressionLimit(of: tissues, at: .init(30), breathing: .air)
        } then: { tissues, limit in
            let expected = try Buhlmann.Table.zhl16c.noDecompressionLimit(
                of: tissues.compartments,
                at: .init(30),
                breathing: .air,
                gradientFactor: try .init(0.85),
                configuration: Self.configuration)
            #expect(limit.result == expected)
            #expect(limit.configuration == Self.configuration)
            guard case .minutes = limit.result else {
                Issue.record("Expected a limit in minutes, got \(limit.result).")
                return
            }
        }
    }

    @Test
    func scheduleSwitchesAtMaximumOperatingDepth() async throws {
        try await given {
            try Self.tissues(breathing: .air, at: 40, for: 30)
        } when: { tissues in
            try Self.calculator.schedule(
                of: tissues,
                from: .init(40),
                breathing: .air,
                switchingTo: [try .enrichedAir(0.5), try .enrichedAir(1)])
        } then: { tissues, schedule in
            let expected = try Buhlmann.Table.zhl16c.schedule(
                of: tissues.compartments,
                from: .init(40),
                breathing: .air,
                switches: [.init(22): try .enrichedAir(0.5), .init(6): try .enrichedAir(1)],
                gradientFactors: try Self.gradientFactors,
                ascent: try .init(rate: .init(9), stopInterval: .init(3), lastStop: .init(3)),
                configuration: Self.configuration)
            #expect(schedule == expected)
            let switchDepths = zip(schedule.result.segments, schedule.result.segments.dropFirst())
                .filter { $0.blend != $1.blend }
                .map(\.1.start.value)
            #expect(switchDepths == [22, 6])
        }
    }

    @Test
    func imperialOxygenSwitchesAtTheStopAtOrAboveItsMaximumOperatingDepth() async throws {
        try await given { () throws -> (calculator: BuhlmannCalculator, tissues: BuhlmannCalculator.Tissues) in
            let calculator = BuhlmannCalculator(.imperial, water: .salt)
            let profile = [
                try DiveSegment(start: .init(0), end: .init(130), duration: .init(4), blend: .air),
                try DiveSegment(start: .init(130), end: .init(130), duration: .init(30), blend: .air)
            ]
            return (calculator, try calculator.loaded(try calculator.surfaceTissues(), through: profile))
        } when: { sut in
            try sut.calculator.schedule(of: sut.tissues, from: .init(130), breathing: .air, switchingTo: [try .enrichedAir(1)]).result
        } then: { _, schedule in
            let oxygen = try Blend.enrichedAir(1)
            let stops = schedule.segments.filter { $0.start == $0.end }
            #expect(stops.contains { $0.start.value == 20 && $0.blend == .air })
            #expect(stops.contains { $0.start.value == 10 && $0.blend == oxygen })
            #expect(schedule.segments.allSatisfy { $0.blend != oxygen || $0.start.value <= 10 })
        }
    }

    @Test
    func imperialOxygenIsNeverUsedWithALastStopDeeperThanItsMaximumOperatingDepth() async throws {
        try await given { () throws -> (calculator: BuhlmannCalculator, tissues: BuhlmannCalculator.Tissues) in
            var settings = BuhlmannCalculator.Settings.defaults(for: .imperial)
            settings.ascent = try .init(rate: .init(30), stopInterval: .init(10), lastStop: .init(20))
            let calculator = BuhlmannCalculator(configuration: .init(units: .imperial, water: .salt), settings: settings)
            let profile = [
                try DiveSegment(start: .init(0), end: .init(130), duration: .init(4), blend: .air),
                try DiveSegment(start: .init(130), end: .init(130), duration: .init(30), blend: .air)
            ]
            return (calculator, try calculator.loaded(try calculator.surfaceTissues(), through: profile))
        } when: { sut in
            try sut.calculator.schedule(of: sut.tissues, from: .init(130), breathing: .air, switchingTo: [try .enrichedAir(1)]).result
        } then: { _, schedule in
            let stops = schedule.segments.filter { $0.start == $0.end }
            #expect(stops.last?.start.value == 20)
            #expect(schedule.segments.allSatisfy { $0.blend == .air })
        }
    }

    @Test
    func duplicateSwitchDepthsUseTheFirstGas() async throws {
        try await given {
            try Self.tissues(breathing: .air, at: 40, for: 30)
        } when: { tissues in
            try Self.calculator.schedule(
                of: tissues,
                from: .init(40),
                breathing: .air,
                switchingTo: [try .trimix(oxygen: 0.5, helium: 0.1), try .enrichedAir(0.5)])
        } then: { _, schedule in
            let blends = schedule.result.segments.map(\.blend)
            let trimix = try Blend.trimix(oxygen: 0.5, helium: 0.1)
            let nitrox = try Blend.enrichedAir(0.5)
            #expect(blends.contains(trimix))
            #expect(!blends.contains(nitrox))
        }
    }

    @Test
    func tissuesKeepTheirTable() async throws {
        try await given {
            try Self.tissues(breathing: .air, at: 40, for: 30)
        } when: { tissues in
            var settings = try Self.calculator.settings
            settings.table = Buhlmann.Table([])
            return try BuhlmannCalculator(configuration: Self.configuration, settings: settings).ceiling(of: tissues)
        } then: { tissues, ceiling in
            let expected = try Self.calculator.ceiling(of: tissues)
            #expect(ceiling == expected)
        }
    }

    @Test
    func loadingRejectsNegativeWaterVapor() async throws {
        try await given { () throws -> (calculator: BuhlmannCalculator, tissues: BuhlmannCalculator.Tissues) in
            var settings = BuhlmannCalculator.Settings.defaults(for: .metric)
            settings.waterVapor = .init(-0.1)
            return (BuhlmannCalculator(configuration: Self.configuration, settings: settings), try Self.calculator.surfaceTissues())
        } when: { sut in
            try expectThrowsError(
                when: try sut.calculator.loaded(
                    sut.tissues,
                    through: [try DiveSegment(start: .init(0), end: .init(10), duration: .init(1), blend: .air)]),
                then: .negative(.pressure(.init(-0.1)), "BuhlmannCalculator.loaded(_:through:)")) { error in
                #expect(error.localizationValue == "dive.kit.error.negative.pressure")
            }
        }
    }

    @Test
    func surfaceTissuesRejectNegativeWaterVapor() async throws {
        try await given {
            var settings = BuhlmannCalculator.Settings.defaults(for: .metric)
            settings.waterVapor = .init(-0.1)
            return BuhlmannCalculator(configuration: Self.configuration, settings: settings)
        } when: { calculator in
            try expectThrowsError(
                when: try calculator.surfaceTissues(),
                then: .negative(.pressure(.init(-0.1)), "BuhlmannCalculator.surfaceTissues()")) { error in
                #expect(error.localizationValue == "dive.kit.error.negative.pressure")
            }
        }
    }

    @Test
    func scheduleRejectsGasRicherThanSwitchPartialPressure() async throws {
        try await given { () throws -> (calculator: BuhlmannCalculator, tissues: BuhlmannCalculator.Tissues) in
            var settings = try Self.calculator.settings
            settings.switchPartialPressure = .init(0.9)
            return (
                calculator: BuhlmannCalculator(configuration: Self.configuration, settings: settings),
                tissues: try Self.tissues(breathing: .air, at: 40, for: 30))
        } when: { sut in
            try expectThrowsError(
                when: try sut.calculator.schedule(of: sut.tissues, from: .init(40), breathing: .air, switchingTo: [try .enrichedAir(1)]),
                then: .negative(.depth(.init((0.9 - 1) * 10)), "BuhlmannCalculator.schedule(of:from:breathing:switchingTo:)")) { error in
                #expect(error.localizationValue == "dive.kit.error.negative.depth")
            }
        }
    }

    @Test(arguments: [
        (partialPressure: -0.1,
         expected: Error.negative(.partialPressure(.init(-0.1)), "BuhlmannCalculator.schedule(of:from:breathing:switchingTo:)"),
         key: "dive.kit.error.negative.partial.pressure"),
        (partialPressure: 0.0,
         expected: .range(.lowerBound(0, 0), "BuhlmannCalculator.schedule(of:from:breathing:switchingTo:)"),
         key: "dive.kit.error.range.lower.bound"),
        (partialPressure: .infinity,
         expected: .range(.upperBound(.infinity, .greatestFiniteMagnitude), "BuhlmannCalculator.schedule(of:from:breathing:switchingTo:)"),
         key: "dive.kit.error.range.upper.bound")
    ])
    func scheduleRejectsInvalidSwitchPartialPressureWithoutSwitches(
        partialPressure: Double,
        expected: Error,
        key: String) async throws {
            try await given { () throws -> (calculator: BuhlmannCalculator, tissues: BuhlmannCalculator.Tissues) in
                var settings = try Self.calculator.settings
                settings.switchPartialPressure = .init(partialPressure)
                return (
                    calculator: BuhlmannCalculator(configuration: Self.configuration, settings: settings),
                    tissues: try Self.calculator.surfaceTissues())
            } when: { sut in
                try expectThrowsError(
                    when: try sut.calculator.schedule(of: sut.tissues, from: .init(0), breathing: .air, switchingTo: []),
                    then: expected) { error in
                    #expect(error.localizationValue == .init(key))
                }
            }
        }

    @Test(arguments: [
        (start: -1.0, end: 0.0, duration: 1.0, expected: Error.negative(.depth(.init(-1)), Self.segmentCallSite), key: "dive.kit.error.negative.depth"),
        (start: 0.0, end: -2.0, duration: 1.0, expected: .negative(.depth(.init(-2)), Self.segmentCallSite), key: "dive.kit.error.negative.depth"),
        (start: 0.0, end: 0.0, duration: -1.0, expected: .negative(.minutes(.init(-1)), Self.segmentCallSite), key: "dive.kit.error.negative.minutes"),
        (start: .infinity, end: 0.0, duration: 1.0,
         expected: .range(.upperBound(.infinity, .greatestFiniteMagnitude), Self.segmentCallSite), key: "dive.kit.error.range.upper.bound"),
        (start: 0.0, end: -.infinity, duration: 1.0,
         expected: .range(.upperBound(-.infinity, .greatestFiniteMagnitude), Self.segmentCallSite), key: "dive.kit.error.range.upper.bound"),
        (start: 0.0, end: 0.0, duration: .infinity,
         expected: .range(.upperBound(.infinity, .greatestFiniteMagnitude), Self.segmentCallSite), key: "dive.kit.error.range.upper.bound")
    ])
    func segmentRejectsInvalidValues(start: Double, end: Double, duration: Double, expected: Error, key: String) throws {
        try expectThrowsError(
            when: try DiveSegment(start: .init(start), end: .init(end), duration: .init(duration), blend: .air),
            then: expected) { error in
            #expect(error.localizationValue == String.LocalizationValue(key))
        }
    }

    @Test
    func zeroLengthSegmentIsAccepted() throws {
        let segment = try DiveSegment(start: .init(0), end: .init(0), duration: .init(0), blend: .air)
        #expect(segment.duration.value == 0)
    }
}

extension BuhlmannCalculatorTests {
    static let configuration = Configuration(units: .metric, water: .salt)

    static let segmentCallSite: CallSite = "DiveSegment.init(start:end:duration:blend:)"

    static var gradientFactors: GradientFactors {
        get throws { try .init(low: try .init(0.3), high: try .init(0.85)) }
    }

    /// A metric salt-water calculator with GF 30/85 and the default ascent.
    static var calculator: BuhlmannCalculator {
        get throws {
            var settings = BuhlmannCalculator.Settings.defaults(for: .metric)
            settings.gradientFactors = try gradientFactors
            return .init(configuration: configuration, settings: settings)
        }
    }

    /// Returns surface tissues after a 2-minute descent and `minutes` at `depth`.
    static func tissues(breathing blend: Blend<Blended>, at depth: Double, for minutes: Double) throws -> BuhlmannCalculator.Tissues {
        try calculator.loaded(
            try calculator.surfaceTissues(),
            through: [
                try DiveSegment(start: .init(0), end: .init(depth), duration: .init(2), blend: blend),
                try DiveSegment(start: .init(depth), end: .init(depth), duration: .init(minutes), blend: blend)
            ])
    }
}
