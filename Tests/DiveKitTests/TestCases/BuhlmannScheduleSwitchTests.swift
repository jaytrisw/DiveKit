import Testing
@_spi(Experimental) @testable import DiveKit
import DiveKitTestSupport

@Suite("Bühlmann schedule gas switches", .tags(.technicalDiving, .buhlmann))
struct BuhlmannScheduleSwitchTests {
    @Test
    func ascentsJoinAndSwitchAtExactDepthBeforeFirstStop() async throws {
        try await given {
            try BuhlmannScheduleReferenceTests.compartments(
                breathing: try .trimix(oxygen: 0.21, helium: 0),
                at: 40,
                runtime: 25)
        } when: { compartments in
            try BuhlmannScheduleReferenceTests.table.schedule(
                of: compartments,
                from: .init(40),
                breathing: try .trimix(oxygen: 0.21, helium: 0),
                switches: [.init(22): try .trimix(oxygen: 0.5, helium: 0)],
                gradientFactors: BuhlmannScheduleTests.gradientFactors,
                ascent: try .init(rate: .init(10), stopInterval: .init(3), lastStop: .init(3)),
                configuration: BuhlmannScheduleReferenceTests.configuration).result
        } then: { _, schedule in
            let air = try Blend.trimix(oxygen: 0.21, helium: 0)
            let nitrox = try Blend.trimix(oxygen: 0.5, helium: 0)
            let first = try #require(schedule.segments.first)
            #expect([first.start.value, first.end.value] == [40, 22])
            #expect(first.duration.value.isApproximately(1.8))
            #expect(first.blend == air)
            let second = try #require(schedule.segments.dropFirst().first)
            #expect([second.start.value, second.end.value] == [22, 18])
            #expect(second.duration.value.isApproximately(0.4))
            #expect(second.blend == nitrox)
        }
    }

    @Test
    func freeAscentStopsAtEachSwitchSharingAStop() async throws {
        // Both switches round down to the 21 m stop, which the free ascent passes.
        try await given {
            try BuhlmannScheduleReferenceTests.compartments(
                breathing: try .trimix(oxygen: 0.21, helium: 0),
                at: 40,
                runtime: 25)
        } when: { compartments in
            try BuhlmannScheduleReferenceTests.table.schedule(
                of: compartments,
                from: .init(40),
                breathing: try .trimix(oxygen: 0.21, helium: 0),
                switches: [.init(22): try .trimix(oxygen: 0.45, helium: 0), .init(21.5): try .trimix(oxygen: 0.5, helium: 0)],
                gradientFactors: BuhlmannScheduleTests.gradientFactors,
                ascent: try .init(rate: .init(10), stopInterval: .init(3), lastStop: .init(3)),
                configuration: BuhlmannScheduleReferenceTests.configuration).result
        } then: { _, schedule in
            let blends = try [0.21, 0.45, 0.5].map { try Blend.trimix(oxygen: $0, helium: 0) }
            let ascents = schedule.segments.prefix(3)
            #expect(ascents.map { [$0.start.value, $0.end.value] } == [[40, 22], [22, 21.5], [21.5, 18]])
            #expect(ascents.map(\.blend) == blends)
        }
    }
}
