import Testing
@_spi(Experimental) @testable import DiveKit

@Suite("Tissue compartment", .tags(.technicalDiving))
struct TissueCompartmentTests {
    @Test
    func constantPressureRespectsGasSpecificHalfTimes() async throws {
        try await given {
            Tissue.Compartment(
                try .init(of: .nitrogen, halfTime: .init(10), tension: .init(0.7)),
                try .init(of: .helium, halfTime: .init(5), tension: .init(0.2)))
        } when: { initial in
            try initial.loaded(
                for: .init(10),
                inspired: try .init(of: .nitrogen, pressure: .init(1.7)), try .init(of: .helium, pressure: .init(0.6)))
        } then: { initial, result in
            let loaded = try #require(result.tracked)
            #expect(loaded.tension(of: .nitrogen)?.isApproximately(1.2) == true)
            #expect(loaded.tension(of: .helium)?.isApproximately(0.5) == true)
            #expect(initial.tension(of: .nitrogen) == 0.7)
            #expect(initial.tension(of: .helium) == 0.2)
        }
    }

    @Test
    func linearDescentMatchesIndependentHighPrecisionCalculation() async throws {
        // Expected values were calculated separately with 50-digit decimal arithmetic.
        try await given {
            Tissue.Compartment(
                try .init(of: .nitrogen, halfTime: .init(10), tension: .init(0.7)),
                try .init(of: .helium, halfTime: .init(5), tension: .init(0.2)))
        } when: { initial in
            try initial.loaded(
                for: .init(10),
                inspired: try .init(of: .nitrogen, from: .init(1), to: .init(2)),
                try .init(of: .helium, from: .init(0.4), to: .init(0.1)))
        } then: { _, result in
            let loaded = try #require(result.tracked)
            #expect(loaded.tension(of: .nitrogen)?.isApproximately(1.1286524795555183) == true)
            #expect(loaded.tension(of: .helium)?.isApproximately(0.21230319210000838) == true)
        }
    }

    @Test
    func linearAscentMatchesIndependentHighPrecisionCalculation() async throws {
        try await given {
            Tissue.Compartment(
                try .init(of: .nitrogen, halfTime: .init(10), tension: .init(1.6)),
                try .init(of: .helium, halfTime: .init(5), tension: .init(0.8)))
        } when: { initial in
            try initial.loaded(
                for: .init(10),
                inspired: try .init(of: .nitrogen, from: .init(2), to: .init(1)),
                try .init(of: .helium, from: .init(1), to: .init(0.2)))
        } then: { _, result in
            let loaded = try #require(result.tracked)
            #expect(loaded.tension(of: .nitrogen)?.isApproximately(1.5213475204444817) == true)
            #expect(loaded.tension(of: .helium)?.isApproximately(0.582808512266689) == true)
        }
    }

    @Test
    func zeroDurationKeepsLoading() async throws {
        try await given {
            Tissue.Compartment(
                try .init(of: .nitrogen, halfTime: .init(10), tension: .init(0.7)),
                try .init(of: .helium, halfTime: .init(5), tension: .init(0.2)))
        } when: { initial in
            try initial.loaded(
                for: .init(0),
                inspired: try .init(of: .nitrogen, from: .init(1), to: .init(2)),
                try .init(of: .helium, from: .init(0.2), to: .init(0.4)))
        } then: { initial, result in
            #expect(result.tracked == initial)
        }
    }

    @Test
    func unlistedTrackedGasOffGasses() async throws {
        try await given {
            Tissue.Compartment(
                try .init(of: .nitrogen, halfTime: .init(10), tension: .init(0.7)),
                try .init(of: .helium, halfTime: .init(5), tension: .init(0.2)))
        } when: { initial in
            try initial.loaded(for: .init(10), inspired: try .init(of: .nitrogen, pressure: .init(1.7)))
        } then: { _, result in
            let loaded = try #require(result.tracked)
            #expect(loaded.tension(of: .nitrogen)?.isApproximately(1.2) == true)
            #expect(loaded.tension(of: .helium)?.isApproximately(0.05) == true)
        }
    }

    @Test
    func untrackedInspiredGasIsReported() async throws {
        try await given {
            Tissue.Compartment(try .init(of: .nitrogen, halfTime: .init(10), tension: .init(0.7)))
        } when: { initial in
            try initial.loaded(
                for: .init(10),
                inspired: try .init(of: .nitrogen, pressure: .init(1.7)), try .init(of: Neon(), pressure: .init(0.4)))
        } then: { _, result in
            let untracked = try #require(result.untracked)
            #expect(untracked.compartment.tension(of: .nitrogen)?.isApproximately(1.2) == true)
            #expect(untracked.compartment.tracking(of: Neon()) == .untracked)
            #expect(untracked.gases.count == 1)
            #expect(untracked.gases.first?.isEqual(to: Neon()) == true)
        }
    }

    @Test
    func metabolicInspiredGasIsIgnoredWithoutBeingReported() async throws {
        try await given {
            Tissue.Compartment(try .init(of: .nitrogen, halfTime: .init(10), tension: .init(0.7)))
        } when: { initial in
            try initial.loaded(
                for: .init(10),
                inspired: try .init(of: .oxygen, pressure: .init(0.4)), try .init(of: .nitrogen, pressure: .init(1.7)))
        } then: { _, result in
            let loaded = try #require(result.tracked)
            #expect(loaded.tension(of: .nitrogen)?.isApproximately(1.2) == true)
            #expect(loaded.tracking(of: .oxygen) == .untracked)
        }
    }

    @Test
    func tracksArbitraryGases() async throws {
        try await given {
            Tissue.Compartment(
                try .init(of: .nitrogen, halfTime: .init(10), tension: .init(0.7)),
                try .init(of: Neon(), halfTime: .init(8), tension: .init(0)))
        } when: { compartment in
            (nitrogen: compartment.tracking(of: .nitrogen),
             neon: compartment.tracking(of: Neon()),
             helium: compartment.tracking(of: .helium),
             gases: compartment.gases())
        } then: { _, tracking in
            #expect(tracking.nitrogen == .tracked(halfTime: .init(10), tension: .init(0.7)))
            #expect(tracking.neon == .tracked(halfTime: .init(8), tension: .init(0)))
            #expect(tracking.helium == .untracked)
            #expect(tracking.gases.count == 2)
        }
    }

    @Test
    func laterComponentReplacesEarlierComponentForSameGas() async throws {
        try await given {
            Tissue.Compartment(
                try .init(of: .nitrogen, halfTime: .init(10), tension: .init(0.7)),
                try .init(of: .nitrogen, halfTime: .init(20), tension: .init(0.9)))
        } when: { compartment in
            compartment.tracking(of: .nitrogen)
        } then: { _, tracking in
            #expect(tracking == .tracked(halfTime: .init(20), tension: .init(0.9)))
        }
    }

    @Test
    func extremeFiniteHalfTimeKeepsLoadingFinite() async throws {
        try await given {
            Tissue.Compartment(try .init(of: .nitrogen, halfTime: .init(.greatestFiniteMagnitude), tension: .init(0.7)))
        } when: { initial in
            try initial.loaded(for: .init(10), inspired: try .init(of: .nitrogen, from: .init(1), to: .init(2)))
        } then: { _, result in
            let loaded = try #require(result.tracked)
            #expect(loaded.tension(of: .nitrogen)?.isApproximately(0.7) == true)
        }
    }

    @Test
    func extremeFiniteTensionsKeepLoadingFinite() async throws {
        try await given {
            Tissue.Compartment(try .init(of: .nitrogen, halfTime: .init(10), tension: .init(.greatestFiniteMagnitude)))
        } when: { initial in
            try initial.loaded(
                for: .init(10),
                inspired: try .init(of: .nitrogen, from: .init(0), to: .init(.greatestFiniteMagnitude)))
        } then: { _, result in
            let loaded = try #require(result.tracked)
            let tension = try #require(loaded.tension(of: .nitrogen))
            #expect((tension / .greatestFiniteMagnitude).isApproximately(0.7786524795555183))
        }
    }

    @Test(.tags(.error))
    func loadingRejectsNegativeDuration() async throws {
        try await given {
            let duration = Minutes(-1)
            let expectedError: Error = .negative(.minutes(duration), "Compartment.loaded(for:inspired:using:)")

            return (
                compartment: Tissue.Compartment(try .init(of: .nitrogen, halfTime: .init(10), tension: .init(0.7))),
                duration: duration,
                expectedError: expectedError)
        } when: { input in
            try expectThrowsError(
                when: try input.compartment.loaded(for: input.duration, inspired: try .init(of: .nitrogen, pressure: .init(1))),
                then: input.expectedError) { error in
                #expect(error.localizationValue == "dive.kit.error.negative.minutes")
            }
        }
    }

    @Test(.tags(.error))
    func loadingRejectsNaNDuration() async throws {
        try await given {
            Tissue.Compartment(try .init(of: .nitrogen, halfTime: .init(10), tension: .init(0.7)))
        } when: { input in
            let error = #expect(throws: Error.self) {
                try input.loaded(for: Minutes(.nan), inspired: try .init(of: .nitrogen, pressure: .init(1)))
            }
            guard case let .range(.upperBound(provided, _), _) = error else {
                Issue.record("Expected an upper-bound error, got \(String(describing: error)).")
                return
            }
            #expect(provided.isNaN)
        }
    }
}
