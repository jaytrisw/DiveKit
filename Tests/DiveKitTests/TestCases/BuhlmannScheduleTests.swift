import Testing
@_spi(Experimental) @testable import DiveKit
@_spi(Experimental) import DiveKitTestSupport

@Suite("Bühlmann schedule", .tags(.technicalDiving, .buhlmann))
struct BuhlmannScheduleTests {
    @Test
    func directAscentUsesHighGradientFactor() async throws {
        try await given {
            try Self.compartments(breathing: .enrichedAir(0.21), at: 30, for: 8)
        } when: { compartments in
            (ceiling: try Buhlmann.Table.zhl16c.ceiling(
                of: compartments,
                gradientFactor: Self.gradientFactors.low,
                configuration: Self.configuration).result.value,
             schedule: try Self.schedule(of: compartments, from: 30, breathing: .enrichedAir(0.21)))
        } then: { _, result in
            let air = try Blend.enrichedAir(0.21)
            #expect(result.ceiling > 0)
            #expect(result.schedule.segments == [.init(unchecked: .init(30), end: .init(0), duration: .init(30.0 / 9), blend: air)])
        }
    }

    @Test
    func lowerGradientFactorsAreMoreConservative() async throws {
        try await given {
            try Self.compartments(breathing: .enrichedAir(0.21), at: 40, for: 30)
        } when: { compartments in
            (base: try Self.schedule(of: compartments, from: 40, breathing: .enrichedAir(0.21)),
             lowerLow: try Self.schedule(
                of: compartments,
                from: 40,
                breathing: .enrichedAir(0.21),
                gradientFactors: try .init(low: try .init(0.1), high: try .init(0.85))),
             lowerHigh: try Self.schedule(
                of: compartments,
                from: 40,
                breathing: .enrichedAir(0.21),
                gradientFactors: try .init(low: try .init(0.3), high: try .init(0.7))))
        } then: { _, schedules in
            let baseFirstStop = try #require(Self.stops(of: schedules.base).first)[0]
            let lowerLowFirstStop = try #require(Self.stops(of: schedules.lowerLow).first)[0]
            #expect(lowerLowFirstStop > baseFirstStop)
            #expect(Self.stopTime(of: schedules.lowerHigh) > Self.stopTime(of: schedules.base))
        }
    }

    @Test
    func stopsAreWholeMinutesOnTheGrid() async throws {
        try await given {
            try Self.compartments(breathing: .enrichedAir(0.21), at: 50, for: 25)
        } when: { compartments in
            try Self.schedule(of: compartments, from: 50, breathing: .enrichedAir(0.21), lastStop: 6)
        } then: { _, schedule in
            let stops = Self.stops(of: schedule)
            #expect(!stops.isEmpty)
            for stop in stops {
                #expect(stop[0] >= 6 && stop[0].truncatingRemainder(dividingBy: 3) == 0)
                #expect(stop[1] >= 1 && stop[1].rounded() == stop[1])
            }
            #expect(stops.last?[0] == 6)
            #expect(schedule.segments.last.map { [$0.start.value, $0.end.value] } == [6, 0])
        }
    }

    @Test
    func switchAtOrDeeperThanStartIsBreathedFromStart() async throws {
        try await given {
            try Self.compartments(breathing: .enrichedAir(0.21), at: 40, for: 30)
        } when: { compartments in
            try Self.schedule(
                of: compartments,
                from: 21,
                breathing: .enrichedAir(0.21),
                switches: [.init(21): try .enrichedAir(0.5), .init(30): try .enrichedAir(0.32)])
        } then: { _, schedule in
            let nitrox = try Blend.enrichedAir(0.5)
            #expect(!schedule.segments.isEmpty)
            #expect(schedule.segments.allSatisfy { $0.blend == nitrox })
        }
    }

    @Test
    func shallowerSwitchWinsWhenSwitchesShareAStop() async throws {
        // Both switches round down to the 21 m stop; the first stop is deeper than 24 m, so the free ascent uses neither.
        let blend = try Blend.trimix(oxygen: 0.18, helium: 0.45)
        try await given {
            try Self.compartments(breathing: blend, at: 60, for: 25)
        } when: { compartments in
            try Self.schedule(of: compartments, from: 60, breathing: blend, switches: [.init(22): try .enrichedAir(0.5), .init(21.5): try .enrichedAir(0.45)])
        } then: { _, schedule in
            let shallower = try Blend.enrichedAir(0.45)
            let stops = schedule.segments.filter { $0.start == $0.end }
            #expect(stops.first.map { $0.start.value > 24 } == true)
            #expect(stops.first { $0.start.value == 21 }?.blend == shallower)
        }
    }

    @Test
    func switchShallowerThanLastStopIsNeverUsed() async throws {
        try await given {
            try Self.compartments(breathing: .enrichedAir(0.21), at: 40, for: 30)
        } when: { compartments in
            try Self.schedule(
                of: compartments,
                from: 40,
                breathing: .enrichedAir(0.21),
                switches: [.init(3): try .enrichedAir(1)],
                lastStop: 6)
        } then: { _, schedule in
            let air = try Blend.enrichedAir(0.21)
            #expect(schedule.segments.allSatisfy { $0.blend == air })
        }
    }

    @Test
    func depthThatCannotBeLeftIsTheFirstStop() async throws {
        // The low-gradient-factor ceiling after this dive is deeper than 10.5 m.
        try await given {
            try Self.compartments(breathing: .enrichedAir(0.21), at: 40, for: 30)
        } when: { compartments in
            try Self.schedule(of: compartments, from: 10.5, breathing: .enrichedAir(0.21))
        } then: { _, schedule in
            let stops = Self.stops(of: schedule)
            #expect(stops.first?[0] == 10.5)
            #expect(stops.dropFirst().first?[0] == 9)
        }
    }

    @Test
    func depthShallowerThanLastStopStopsInPlace() async throws {
        try await given {
            try Self.compartments(breathing: .enrichedAir(0.21), at: 40, for: 30)
        } when: { compartments in
            try Self.schedule(of: compartments, from: 2, breathing: .enrichedAir(0.21))
        } then: { _, schedule in
            #expect(schedule.segments.map { [$0.start.value, $0.end.value] } == [[2, 2], [2, 0]])
        }
    }

    @Test
    func surfaceGivesEmptySchedule() async throws {
        try await given {
            try Buhlmann.Table.zhl16c.compartments(nitrogen: .init(3))
        } when: { compartments in
            try Self.schedule(of: compartments, from: 0, breathing: .enrichedAir(0.21))
        } then: { _, schedule in
            #expect(schedule.segments.isEmpty)
        }
    }

    @Test
    func stopsThatNeverClearThrow() async throws {
        // At GF 0.01 a compartment tolerates little more than ambient pressure, and
        // breathing 90% inert gas at 9 m keeps every tension above 6 m's pressure.
        try await given {
            try Buhlmann.Table.zhl16c.compartments(nitrogen: .init(2))
        } when: { compartments in
            try expectThrowsError(
                when: try Self.schedule(
                    of: compartments,
                    from: 9,
                    breathing: .trimix(oxygen: 0.1, helium: 0.8),
                    gradientFactors: try .init(low: try .init(0.01), high: try .init(0.01))),
                then: .range(.upperBound(1000, 999), Self.callSite)) { error in
                #expect(error.localizationValue == "dive.kit.error.range.upper.bound")
            }
        }
    }

    @Test
    func reloadingSegmentsReproducesEachStopDecision() async throws {
        let blend = try Blend.trimix(oxygen: 0.21, helium: 0.35)
        try await given {
            try Self.compartments(breathing: blend, at: 50, for: 25)
        } when: { compartments in
            (compartments: compartments,
             schedule: try Self.schedule(
                of: compartments,
                from: 50,
                breathing: blend,
                switches: [.init(21): try .enrichedAir(0.5), .init(6): try .enrichedAir(1)]))
        } then: { _, result in
            let segments = result.schedule.segments
            let firstStop = try #require(segments.first { $0.start == $0.end }).start.value
            var compartments = result.compartments
            for (index, segment) in segments.enumerated() {
                guard segment.start == segment.end else {
                    compartments = try Self.loaded(compartments, over: segment, for: segment.duration.value)
                    continue
                }
                let next = try #require(segments.dropFirst(index + 1).first).end.value
                let gradientFactor = try GradientFactor(0.85 - (0.85 - 0.3) * next / firstStop)
                let leaving = try Self.loaded(compartments, over: segment, for: segment.duration.value)
                #expect(try Self.toleratedAmbientPressure(of: leaving, gradientFactor: gradientFactor) <= 1 + next / 10)
                if segment.duration.value > 1 {
                    let earlier = try Self.loaded(compartments, over: segment, for: segment.duration.value - 1)
                    #expect(try Self.toleratedAmbientPressure(of: earlier, gradientFactor: gradientFactor) > 1 + next / 10)
                }
                compartments = leaving
            }
        }
    }

    @Test
    func scheduleDoesNotDependOnCompartmentOrder() async throws {
        try await given {
            try Self.compartments(breathing: .enrichedAir(0.21), at: 40, for: 30)
        } when: { compartments in
            (inOrder: try Self.schedule(of: compartments, from: 40, breathing: .enrichedAir(0.21)),
             reversed: try Self.schedule(of: compartments.reversed(), from: 40, breathing: .enrichedAir(0.21)))
        } then: { _, schedules in
            #expect(schedules.inOrder == schedules.reversed)
        }
    }

    @Test
    func withoutWaterVaporStopsAreLonger() async throws {
        try await given {
            try Self.compartments(breathing: .enrichedAir(0.21), at: 40, for: 30)
        } when: { compartments in
            (base: try Self.schedule(of: compartments, from: 40, breathing: .enrichedAir(0.21)),
             dry: try Buhlmann.Table.zhl16c.schedule(
                of: compartments,
                from: .init(40),
                breathing: try .enrichedAir(0.21),
                gradientFactors: Self.gradientFactors,
                ascent: try .init(rate: .init(9), stopInterval: .init(3), lastStop: .init(3)),
                waterVapor: .init(0),
                configuration: Self.configuration).result)
        } then: { _, schedules in
            #expect(Self.stopTime(of: schedules.dry) > Self.stopTime(of: schedules.base))
        }
    }

    @Test
    func loadingModelIsUsed() async throws {
        // Every compartment reaches the inspired pressure at once, so the direct ascent clears.
        try await given {
            try Buhlmann.Table.zhl16c.compartments(nitrogen: .init(3))
        } when: { compartments in
            try Buhlmann.Table.zhl16c.schedule(
                of: compartments,
                from: .init(30),
                breathing: try .enrichedAir(0.21),
                gradientFactors: Self.gradientFactors,
                ascent: try .init(rate: .init(9), stopInterval: .init(3), lastStop: .init(3)),
                configuration: Self.configuration,
                using: Tissue.Loading { _, inspired, _, _ in inspired.to }).result
        } then: { _, schedule in
            #expect(schedule.segments.count == 1)
        }
    }

    @Test
    func untrackedBlendGasIsIgnored() async throws {
        // Both blends are 44% nitrogen, and a nitrogen-only compartment ignores the trimix's helium.
        try await given {
            [Tissue.Compartment(try .init(of: .nitrogen, halfTime: .init(54.3), tension: .init(2.5)))]
        } when: { compartments in
            try [Blend.trimix(oxygen: 0.21, helium: 0.35), .enrichedAir(0.56)].map { Self.stops(of: try Self.schedule(of: compartments, from: 40, breathing: $0)) }
        } then: { _, stops in
            #expect(!stops[1].isEmpty)
            #expect(stops[0] == stops[1])
        }
    }

    @Test
    func unmodeledGasThrows() async throws {
        try await given {
            [Tissue.Compartment(try .init(of: .helium, halfTime: .init(4), tension: .init(0.1)))]
        } when: { compartments in
            try expectThrowsError(
                when: try Self.schedule(of: compartments, from: 30, breathing: .enrichedAir(0.21)),
                then: .gas(.unmodeled(Helium.helium), Self.callSite)) { error in
                #expect(error.localizationValue == "dive.kit.error.gas.unmodeled")
            }
        }
    }

    @Test
    func rejectsNegativeModelResult() async throws {
        try await given {
            try Buhlmann.Table.zhl16c.compartments(nitrogen: .init(0.74))
        } when: { compartments in
            try expectThrowsError(
                when: try Buhlmann.Table.zhl16c.schedule(
                    of: compartments,
                    from: .init(30),
                    breathing: try .enrichedAir(0.21),
                    ascent: try .init(rate: .init(9), stopInterval: .init(3), lastStop: .init(3)),
                    configuration: Self.configuration,
                    using: Tissue.Loading { _, _, _, _ in -1 }),
                then: .negative(.partialPressure(-1), Self.callSite)) { error in
                #expect(error.localizationValue == "dive.kit.error.negative.partial.pressure")
            }
        }
    }
}

extension BuhlmannScheduleTests {
    static let configuration = Configuration(units: .metric, water: .salt)

    static let callSite: CallSite = "Table.schedule(of:from:breathing:switches:gradientFactors:ascent:waterVapor:configuration:using:)"

    static var gradientFactors: GradientFactors {
        get throws { try .init(low: try .init(0.3), high: try .init(0.85)) }
    }

    /// Returns ZH-L16C compartments after breathing `blend` at a constant depth, starting saturated at the surface.
    static func compartments(breathing blend: Blend<Blended>, at depth: Double, for minutes: Double) throws -> [Tissue.Compartment] {
        try loaded(
            try Buhlmann.Table.zhl16c.compartments(nitrogen: .init(0.74)),
            over: .init(unchecked: .init(depth), end: .init(depth), duration: .init(minutes), blend: blend),
            for: minutes)
    }

    /// Returns ZH-L16C schedule with GF 30/85, a 9 m/min ascent and 3 m stops.
    static func schedule(
        of compartments: [Tissue.Compartment],
        from depth: Double,
        breathing blend: Blend<Blended>,
        switches: [Depth: Blend<Blended>] = [:],
        gradientFactors: GradientFactors? = nil,
        lastStop: Double = 3) throws -> DecompressionSchedule {
            try Buhlmann.Table.zhl16c.schedule(
                of: compartments,
                from: .init(depth),
                breathing: blend,
                switches: switches,
                gradientFactors: try gradientFactors ?? Self.gradientFactors,
                ascent: try .init(rate: .init(9), stopInterval: .init(3), lastStop: .init(lastStop)),
                configuration: configuration).result
        }

    /// Returns each compartment after the first `minutes` of a segment, through the public loading path.
    static func loaded(
        _ compartments: [Tissue.Compartment],
        over segment: DiveSegment,
        for minutes: Double) throws -> [Tissue.Compartment] {
            let end = minutes == segment.duration.value
                ? segment.end.value
                : segment.start.value + (segment.end.value - segment.start.value) * minutes / segment.duration.value
            return try compartments.map { compartment in
                try #require(try compartment.loaded(
                    for: .init(minutes),
                    inspired: try Tissue.Inspired(
                        of: .nitrogen, breathing: segment.blend, from: segment.start, to: .init(end), configuration: configuration),
                    try Tissue.Inspired(
                        of: .helium, breathing: segment.blend, from: segment.start, to: .init(end), configuration: configuration)).tracked)
            }
        }

    static func toleratedAmbientPressure(
        of compartments: [Tissue.Compartment],
        gradientFactor: GradientFactor) throws -> Double {
            try compartments
                .map { try Buhlmann.Table.zhl16c.toleratedAmbientPressure(of: $0, gradientFactor: gradientFactor).value }
                .reduce(0, max)
        }

    /// Returns each stop as `[depth, minutes]`.
    static func stops(of schedule: DecompressionSchedule) -> [[Double]] {
        schedule.segments.filter { $0.start == $0.end }.map { [$0.start.value, $0.duration.value] }
    }

    static func stopTime(of schedule: DecompressionSchedule) -> Double {
        stops(of: schedule).reduce(0) { $0 + $1[1] }
    }
}
