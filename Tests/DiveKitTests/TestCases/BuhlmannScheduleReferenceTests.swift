import Testing
@_spi(Experimental) @testable import DiveKit

/// Schedules checked against decotengu 0.14.1, an independent ZH-L16-GF planner.
///
/// Expected values are decotengu's output for `Engine.calculate(depth, runtime)`
/// with `ZH_L16C_GF`, its default ascent rate of 10 m/min, descent rate of
/// 20 m/min and 3 m stops. Its conventions are reproduced exactly: a surface of
/// 1.01325 bar, 0.09985 bar per meter, 0.0627 bar water vapor, starting nitrogen
/// of 0.7902 · (1.01325 − 0.0627) bar, and a table that uses compartment 1
/// (4 minutes) rather than 1b. Every pressure comparison clears its limit by at
/// least 1e-4 bar, and every rounded ceiling is at least 0.07 of a stop interval
/// from a stop depth.
@Suite("Bühlmann schedule reference", .tags(.technicalDiving, .buhlmann))
struct BuhlmannScheduleReferenceTests {
    struct Reference: Sendable, CustomTestStringConvertible {
        let label: String
        let depth: Double
        let runtime: Double
        let oxygen: Double
        let helium: Double
        var switches: [Double: Double] = [:]
        var gradientFactors = (low: 0.3, high: 0.85)
        var lastStop = 3.0
        let stops: [[Double]]
        var switchDepths: [Double] = []
        let surfacedAt: Double

        var testDescription: String { label }
    }

    @Test(arguments: [
        Reference(
            label: "Air, 40 m",
            depth: 40, runtime: 25, oxygen: 0.21, helium: 0,
            stops: [[18, 1], [15, 1], [12, 2], [9, 3], [6, 6], [3, 16]],
            surfacedAt: 58),
        Reference(
            label: "Air, 20 m, no stops",
            depth: 20, runtime: 20, oxygen: 0.21, helium: 0,
            stops: [],
            surfacedAt: 22),
        Reference(
            label: "Air, 40 m, GF 100/100",
            depth: 40, runtime: 25, oxygen: 0.21, helium: 0,
            gradientFactors: (low: 1, high: 1),
            stops: [[6, 4], [3, 11]],
            surfacedAt: 44),
        Reference(
            label: "Air, 40 m, last stop 6 m",
            depth: 40, runtime: 25, oxygen: 0.21, helium: 0,
            lastStop: 6,
            stops: [[18, 1], [15, 1], [12, 2], [9, 3], [6, 31]],
            surfacedAt: 67),
        Reference(
            label: "EAN32, 30 m, EAN50 at 21 m and oxygen at 6 m",
            depth: 30, runtime: 60, oxygen: 0.32, helium: 0,
            switches: [21: 0.5, 6: 1],
            stops: [[12, 1], [9, 2], [6, 4], [3, 7]],
            switchDepths: [21, 6],
            surfacedAt: 77),
        Reference(
            label: "Air, 40 m, EAN50 at 22 m before the first stop",
            depth: 40, runtime: 25, oxygen: 0.21, helium: 0,
            switches: [22: 0.5, 6: 1],
            stops: [[18, 1], [15, 1], [12, 1], [9, 1], [6, 3], [3, 5]],
            switchDepths: [22, 6],
            surfacedAt: 41),
        Reference(
            label: "Air, 45 m, EAN50 at 22 m undone at the first stop",
            depth: 45, runtime: 40, oxygen: 0.21, helium: 0,
            switches: [22: 0.5],
            stops: [[24, 1], [21, 1], [18, 2], [15, 3], [12, 4], [9, 7], [6, 12], [3, 21]],
            switchDepths: [21],
            surfacedAt: 95.5),
        Reference(
            label: "Tx 18/45, 60 m, EAN50 at 21 m and oxygen at 6 m",
            depth: 60, runtime: 25, oxygen: 0.18, helium: 0.45,
            switches: [21: 0.5, 6: 1],
            stops: [[33, 1], [30, 1], [27, 1], [24, 2], [21, 1], [18, 2], [15, 2], [12, 4], [9, 6], [6, 8], [3, 14]],
            switchDepths: [21, 6],
            surfacedAt: 73)
    ])
    func matchesDecotengu(_ reference: Reference) async throws {
        try await given {
            try Self.compartments(
                breathing: try .trimix(oxygen: reference.oxygen, helium: reference.helium),
                at: reference.depth,
                runtime: reference.runtime)
        } when: { compartments in
            try Self.table.schedule(
                of: compartments,
                from: .init(reference.depth),
                breathing: try .trimix(oxygen: reference.oxygen, helium: reference.helium),
                switches: Dictionary(uniqueKeysWithValues: try reference.switches.map { depth, oxygen in
                    (Depth(depth), try Blend.trimix(oxygen: oxygen, helium: 0))
                }),
                gradientFactors: try .init(
                    low: try .init(reference.gradientFactors.low),
                    high: try .init(reference.gradientFactors.high)),
                ascent: try .init(rate: .init(10), stopInterval: .init(3), lastStop: .init(reference.lastStop)),
                configuration: Self.configuration).result
        } then: { _, schedule in
            let stops = schedule.segments.filter { $0.start == $0.end }
            #expect(stops.map { [$0.start.value, $0.duration.value] } == reference.stops)
            let switchDepths = zip(schedule.segments, schedule.segments.dropFirst())
                .filter { $0.blend != $1.blend }
                .map { $1.start.value }
            #expect(switchDepths == reference.switchDepths)
            let runtime = schedule.segments.reduce(reference.runtime) { $0 + $1.duration.value }
            #expect(runtime.isApproximately(reference.surfacedAt, with: .loose))
            #expect(schedule.segments.first?.start.value == reference.depth)
            #expect(schedule.segments.last?.end.value == 0)
        }
    }
}

extension BuhlmannScheduleReferenceTests {
    /// decotengu's `ZH_L16C_GF` table: DiveKit's ZH-L16C with compartment 1 instead of 1b.
    static let table: Buhlmann.Table = {
        var rows = Buhlmann.Table.zhl16c.rows
        rows[0] = .init(
            nitrogen: .init(.nitrogen, halfTime: 4.0, bar: 1.2599, b: 0.5050),
            helium: .init(.helium, halfTime: 1.51, bar: 1.7424, b: 0.4245))
        return .init(rows)
    }()

    /// Salt water at 0.09985 bar per meter, with the surface at 1.01325 bar.
    static let configuration = Configuration(
        units: .metric,
        water: Water(weight: Water.salt.weight, pressure: { .init(increase: .init(1.01325 / 0.09985, units: $0)) }))

    /// Returns decotengu's compartments after its descent at 20 m/min and the rest of the bottom time.
    static func compartments(breathing blend: Blend<Blended>, at depth: Double, runtime: Double) throws -> [Tissue.Compartment] {
        let descent = depth / 20
        return try table.compartments(nitrogen: .init(0.7902 * (1.01325 - 0.0627) / 1.01325)).map { compartment in
            let descended = try #require(try compartment.loaded(
                for: .init(descent),
                inspired: try Tissue.Inspired(
                    of: .nitrogen, breathing: blend, from: .init(0), to: .init(depth), configuration: configuration),
                try Tissue.Inspired(
                    of: .helium, breathing: blend, from: .init(0), to: .init(depth), configuration: configuration)).tracked)
            return try #require(try descended.loaded(
                for: .init(runtime - descent),
                inspired: try Tissue.Inspired(of: .nitrogen, breathing: blend, at: .init(depth), configuration: configuration),
                try Tissue.Inspired(of: .helium, breathing: blend, at: .init(depth), configuration: configuration)).tracked)
        }
    }
}
