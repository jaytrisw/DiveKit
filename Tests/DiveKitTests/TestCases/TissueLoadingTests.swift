import Testing
@_spi(Experimental) @testable import DiveKit
@_spi(Experimental) import DiveKitTestSupport

@Suite("Tissue loading", .tags(.technicalDiving))
struct TissueLoadingTests {
    @Test(.tags(.schreiner))
    func schreinerLoadsAtConstantPressure() async throws {
        try await given {
            Tissue.Compartment(
                try .init(of: .nitrogen, halfTime: .init(10), tension: .init(0.7)),
                try .init(of: .helium, halfTime: .init(5), tension: .init(0.2)))
        } when: { initial in
            try initial.loaded(
                for: .init(10),
                inspired: try .init(of: .nitrogen, pressure: .init(1.7)), try .init(of: .helium, pressure: .init(0.6)),
                using: .schreiner)
        } then: { initial, result in
            let loaded = try #require(result.tracked)
            #expect(loaded.tension(of: .nitrogen)?.isApproximately(1.2) == true)
            #expect(loaded.tension(of: .helium)?.isApproximately(0.5) == true)
            #expect(initial.tension(of: .nitrogen) == 0.7)
            #expect(initial.tension(of: .helium) == 0.2)
        }
    }

    @Test(.tags(.haldane))
    func haldaneLoadsAtConstantPressure() async throws {
        try await given {
            Tissue.Compartment(
                try .init(of: .nitrogen, halfTime: .init(10), tension: .init(0.7)),
                try .init(of: .helium, halfTime: .init(5), tension: .init(0.2)))
        } when: { initial in
            try initial.loaded(
                for: .init(10),
                inspired: try .init(of: .nitrogen, pressure: .init(1.7)), try .init(of: .helium, pressure: .init(0.6)),
                using: .haldane)
        } then: { _, result in
            let loaded = try #require(result.tracked)
            #expect(loaded.tension(of: .nitrogen)?.isApproximately(1.2) == true)
            #expect(loaded.tension(of: .helium)?.isApproximately(0.5) == true)
        }
    }

    @Test(.tags(.schreiner))
    func schreinerIsExactDuringLinearChange() async throws {
        // Expected values are from Tests/Reference/BuhlmannReference.swift (38-digit Decimal),
        // compared within the standard 1e-12 tolerance.
        try await given {
            Tissue.Compartment(
                try .init(of: .nitrogen, halfTime: .init(10), tension: .init(0.7)),
                try .init(of: .helium, halfTime: .init(5), tension: .init(0.2)))
        } when: { initial in
            try initial.loaded(
                for: .init(10),
                inspired: try .init(of: .nitrogen, from: .init(1), to: .init(2)),
                try .init(of: .helium, from: .init(0.4), to: .init(0.1)),
                using: .schreiner)
        } then: { _, result in
            let loaded = try #require(result.tracked)
            #expect(loaded.tension(of: .nitrogen)?.isApproximately(1.1286524795555183) == true)
            #expect(loaded.tension(of: .helium)?.isApproximately(0.21230319210000838) == true)
        }
    }

    @Test(.tags(.haldane))
    func haldaneUsesMeanInspiredPressureDuringLinearChange() async throws {
        try await given {
            Tissue.Compartment(
                try .init(of: .nitrogen, halfTime: .init(10), tension: .init(0.7)),
                try .init(of: .helium, halfTime: .init(5), tension: .init(0.2)))
        } when: { initial in
            try initial.loaded(
                for: .init(10),
                inspired: try .init(of: .nitrogen, from: .init(1), to: .init(2)),
                try .init(of: .helium, from: .init(0.4), to: .init(0.1)),
                using: .haldane)
        } then: { _, result in
            let loaded = try #require(result.tracked)
            #expect(loaded.tension(of: .nitrogen)?.isApproximately(1.1) == true)
            #expect(loaded.tension(of: .helium)?.isApproximately(0.2375) == true)
        }
    }

    @Test
    func customModelReceivesEachGasSegment() async throws {
        try await given {
            Tissue.Compartment(
                try .init(of: .nitrogen, halfTime: .init(10), tension: .init(0.7)),
                try .init(of: .helium, halfTime: .init(5), tension: .init(0.2)))
        } when: { initial in
            try initial.loaded(
                for: .init(3),
                inspired: try .init(of: .nitrogen, from: .init(1), to: .init(2)),
                try .init(of: .helium, from: .init(0.4), to: .init(0.1)),
                using: .init { tension, inspired, halfTime, duration in
                    tension + inspired.from + inspired.to + halfTime + duration
                })
        } then: { _, result in
            let loaded = try #require(result.tracked)
            #expect(loaded.tension(of: .nitrogen)?.isApproximately(16.7) == true)
            #expect(loaded.tension(of: .helium)?.isApproximately(8.7) == true)
        }
    }

    @Test(.tags(.schreiner))
    func schreinerHandlesSmallestHalfTime() async throws {
        try await given {
            Tissue.Compartment(try .init(of: .nitrogen, halfTime: .init(.leastNonzeroMagnitude), tension: .init(0)))
        } when: { initial in
            try initial.loaded(
                for: .init(.leastNonzeroMagnitude),
                inspired: try .init(of: .nitrogen, pressure: .init(1)),
                using: .schreiner)
        } then: { _, result in
            let loaded = try #require(result.tracked)
            #expect(loaded.tension(of: .nitrogen)?.isApproximately(0.5) == true)
        }
    }

    @Test(.tags(.schreiner))
    func schreinerHandlesLargestPressures() async throws {
        try await given {
            Tissue.Compartment(try .init(of: .nitrogen, halfTime: .init(10), tension: .init(.greatestFiniteMagnitude)))
        } when: { initial in
            // Unclamped, the separately rounded terms sum past the largest finite value for this duration.
            try initial.loaded(
                for: .init(20.01),
                inspired: try .init(of: .nitrogen, pressure: .init(.greatestFiniteMagnitude)),
                using: .schreiner)
        } then: { _, result in
            let loaded = try #require(result.tracked)
            #expect(loaded.tension(of: .nitrogen) == .greatestFiniteMagnitude)
        }
    }

    @Test(.tags(.haldane))
    func haldaneHandlesSmallestHalfTime() async throws {
        try await given {
            Tissue.Compartment(try .init(of: .nitrogen, halfTime: .init(.leastNonzeroMagnitude), tension: .init(0)))
        } when: { initial in
            try initial.loaded(
                for: .init(.leastNonzeroMagnitude),
                inspired: try .init(of: .nitrogen, pressure: .init(1)),
                using: .haldane)
        } then: { _, result in
            let loaded = try #require(result.tracked)
            #expect(loaded.tension(of: .nitrogen)?.isApproximately(0.5) == true)
        }
    }

    @Test(.tags(.error))
    func loadingRejectsNegativeModelResult() async throws {
        try await given {
            let expectedError: Error = .negative(.partialPressure(-1), "Compartment.loaded(for:inspired:using:)")

            return (
                compartment: Tissue.Compartment(try .init(of: .nitrogen, halfTime: .init(10), tension: .init(0.7))),
                model: Tissue.Loading { _, _, _, _ in -1 },
                expectedError: expectedError)
        } when: { input in
            try expectThrowsError(
                when: try input.compartment.loaded(
                    for: .init(5),
                    inspired: try .init(of: .nitrogen, pressure: .init(1)),
                    using: input.model),
                then: input.expectedError) { error in
                #expect(error.localizationValue == "dive.kit.error.negative.partial.pressure")
            }
        }
    }

    @Test(.tags(.error))
    func loadingRejectsInfiniteModelResult() async throws {
        try await given {
            let expectedError: Error = .range(
                .upperBound(.infinity, .greatestFiniteMagnitude),
                "Compartment.loaded(for:inspired:using:)")

            return (
                compartment: Tissue.Compartment(try .init(of: .nitrogen, halfTime: .init(10), tension: .init(0.7))),
                model: Tissue.Loading { _, _, _, _ in .infinity },
                expectedError: expectedError)
        } when: { input in
            try expectThrowsError(
                when: try input.compartment.loaded(
                    for: .init(5),
                    inspired: try .init(of: .nitrogen, pressure: .init(1)),
                    using: input.model),
                then: input.expectedError) { error in
                #expect(error.localizationValue == "dive.kit.error.range.upper.bound")
            }
        }
    }

    @Test(.tags(.error))
    func loadingRejectsNaNModelResult() async throws {
        try await given {
            (
                compartment: Tissue.Compartment(try .init(of: .nitrogen, halfTime: .init(10), tension: .init(0.7))),
                model: Tissue.Loading { _, _, _, _ in .nan })
        } when: { input in
            let error = #expect(throws: Error.self) {
                try input.compartment.loaded(
                    for: .init(5),
                    inspired: try .init(of: .nitrogen, pressure: .init(1)),
                    using: input.model)
            }
            guard case let .range(.upperBound(provided, upperBound), callSite) = error else {
                Issue.record("Expected an upper-bound error, got \(String(describing: error)).")
                return
            }
            #expect(provided.isNaN)
            #expect(upperBound == .greatestFiniteMagnitude)
            #expect(callSite == "Compartment.loaded(for:inspired:using:)")
            #expect(error?.localizationValue == "dive.kit.error.range.upper.bound")
        }
    }
}
