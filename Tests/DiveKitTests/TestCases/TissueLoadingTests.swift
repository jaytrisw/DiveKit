import Testing
@_spi(Experimental) @testable import DiveKit

@Suite("Tissue loading", .tags(.technicalDiving))
struct TissueLoadingTests {
    @Test
    func haldaneMatchesSchreinerAtConstantPressure() async throws {
        try await given {
            Tissue.Compartment(
                try .init(of: .nitrogen, halfTime: .init(10), tension: .init(0.7)),
                try .init(of: .helium, halfTime: .init(5), tension: .init(0.2)))
        } when: { initial in
            (
                haldane: try initial.loaded(
                    for: .init(10),
                    inspired: try .init(of: .nitrogen, pressure: .init(1.7)), try .init(of: .helium, pressure: .init(0.6)),
                    using: .haldane),
                schreiner: try initial.loaded(
                    for: .init(10),
                    inspired: try .init(of: .nitrogen, pressure: .init(1.7)), try .init(of: .helium, pressure: .init(0.6)),
                    using: .schreiner))
        } then: { _, loaded in
            let haldane = try #require(loaded.haldane.tracked)
            let schreiner = try #require(loaded.schreiner.tracked)
            let schreinerNitrogen = try #require(schreiner.tension(of: .nitrogen))
            let schreinerHelium = try #require(schreiner.tension(of: .helium))
            #expect(haldane.tension(of: .nitrogen)?.isApproximately(schreinerNitrogen) == true)
            #expect(haldane.tension(of: .helium)?.isApproximately(schreinerHelium) == true)
        }
    }

    @Test
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

    @Test
    func modelsHandleSmallestHalfTime() async throws {
        try await given {
            Tissue.Compartment(try .init(of: .nitrogen, halfTime: .init(.leastNonzeroMagnitude), tension: .init(0)))
        } when: { initial in
            (
                schreiner: try initial.loaded(
                    for: .init(.leastNonzeroMagnitude),
                    inspired: try .init(of: .nitrogen, pressure: .init(1)),
                    using: .schreiner),
                haldane: try initial.loaded(
                    for: .init(.leastNonzeroMagnitude),
                    inspired: try .init(of: .nitrogen, pressure: .init(1)),
                    using: .haldane))
        } then: { _, loaded in
            let schreiner = try #require(loaded.schreiner.tracked)
            let haldane = try #require(loaded.haldane.tracked)
            #expect(schreiner.tension(of: .nitrogen)?.isApproximately(0.5) == true)
            #expect(haldane.tension(of: .nitrogen)?.isApproximately(0.5) == true)
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
            guard case let .range(.upperBound(provided, _), _) = error else {
                Issue.record("Expected an upper-bound error, got \(String(describing: error)).")
                return
            }
            #expect(provided.isNaN)
        }
    }
}
