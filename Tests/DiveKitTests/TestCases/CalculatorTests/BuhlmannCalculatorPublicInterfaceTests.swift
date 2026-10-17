import Testing
@_spi(Experimental) import DiveKit

/// Uses only what a client of `@_spi(Experimental) import DiveKit` can name.
@Suite("Bühlmann calculator public interface", .tags(.technicalDiving, .buhlmannCalculator))
struct BuhlmannCalculatorPublicInterfaceTests {
    @Test
    func settingsCanBeCustomizedThroughDiveKit() async throws {
        try await given {
            var settings = BuhlmannCalculator.Settings.defaults(for: .metric)
            settings.gradientFactors = try GradientFactors(low: try GradientFactor(0.3), high: try GradientFactor(0.85))
            settings.ascent = try Ascent(rate: .init(10), stopInterval: .init(3), lastStop: .init(6))
            return BuhlmannCalculator(configuration: .init(units: .metric, water: .salt), settings: settings)
        } when: { (calculator: BuhlmannCalculator) throws -> (limit: NoDecompressionLimit, schedule: DecompressionSchedule) in
            let tissues = try calculator.loaded(
                try calculator.surfaceTissues(),
                through: [
                    try DiveSegment(start: .init(0), end: .init(40), duration: .init(2), blend: .air),
                    try DiveSegment(start: .init(40), end: .init(40), duration: .init(30), blend: .air)
                ])
            let limit: NoDecompressionLimit = try calculator.noDecompressionLimit(of: tissues, at: .init(40), breathing: .air).result
            let schedule: DecompressionSchedule = try calculator.schedule(
                of: tissues,
                from: .init(40),
                breathing: .air,
                switchingTo: [try .enrichedAir(0.5)]).result
            return (limit: limit, schedule: schedule)
        } then: { _, result in
            #expect(result.limit == .exceeded)
            let stops = result.schedule.segments.filter { $0.start == $0.end }
            #expect(stops.last?.start.value == 6)
            #expect(result.schedule.segments.last?.end.value == 0)
        }
    }

    @Test
    func calculatorConformsToDecompressionCalculating() throws {
        func ceiling(using calculator: some DecompressionCalculating) throws -> Double {
            try calculator.ceiling(of: try calculator.surfaceTissues()).result.value
        }
        let value = try ceiling(using: BuhlmannCalculator(.metric, water: .salt))
        #expect(value == 0)
    }
}
