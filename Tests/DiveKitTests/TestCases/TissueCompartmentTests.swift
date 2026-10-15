import Testing
@_spi(Experimental) @testable import DiveKit

@Suite("Tissue compartment", .tags(.technicalDiving))
struct TissueCompartmentTests {
    @Test
    func constantPressureRespectsGasSpecificHalfTimes() async throws {
        try await given {
            try TissueCompartment(
                halfTimes: .init(nitrogen: .init(10), helium: .init(5)),
                nitrogen: .init(0.7),
                helium: .init(0.2))
        } when: { initial in
            try initial.loaded(
                for: .init(10),
                inspiredNitrogen: .init(1.7),
                inspiredHelium: .init(0.6))
        } then: { initial, loaded in
            #expect(loaded.halfTimes == initial.halfTimes)
            #expect(loaded.nitrogen.value.isApproximately(1.2))
            #expect(loaded.helium.value.isApproximately(0.5))
            #expect(initial.nitrogen.value == 0.7)
            #expect(initial.helium.value == 0.2)
        }
    }

    @Test
    func linearDescentMatchesIndependentHighPrecisionCalculation() async throws {
        // Expected values were calculated separately with 50-digit decimal arithmetic.
        try await given {
            try TissueCompartment(
                halfTimes: .init(nitrogen: .init(10), helium: .init(5)),
                nitrogen: .init(0.7),
                helium: .init(0.2))
        } when: { initial in
            try initial.loaded(
                for: .init(10),
                nitrogenFrom: .init(1),
                nitrogenTo: .init(2),
                heliumFrom: .init(0.4),
                heliumTo: .init(0.1))
        } then: { _, loaded in
            #expect(loaded.nitrogen.value.isApproximately(1.1286524795555183))
            #expect(loaded.helium.value.isApproximately(0.21230319210000838))
        }
    }

    @Test
    func linearAscentMatchesIndependentHighPrecisionCalculation() async throws {
        try await given {
            try TissueCompartment(
                halfTimes: .init(nitrogen: .init(10), helium: .init(5)),
                nitrogen: .init(1.6),
                helium: .init(0.8))
        } when: { initial in
            try initial.loaded(
                for: .init(10),
                nitrogenFrom: .init(2),
                nitrogenTo: .init(1),
                heliumFrom: .init(1),
                heliumTo: .init(0.2))
        } then: { _, loaded in
            #expect(loaded.nitrogen.value.isApproximately(1.5213475204444817))
            #expect(loaded.helium.value.isApproximately(0.582808512266689))
        }
    }

    @Test
    func zeroDurationKeepsLoading() async throws {
        try await given {
            try TissueCompartment(
                halfTimes: .init(nitrogen: .init(10), helium: .init(5)),
                nitrogen: .init(0.7),
                helium: .init(0.2))
        } when: { initial in
            try initial.loaded(
                for: .init(0),
                nitrogenFrom: .init(1),
                nitrogenTo: .init(2),
                heliumFrom: .init(0.2),
                heliumTo: .init(0.4))
        } then: { initial, loaded in
            #expect(loaded == initial)
        }
    }

    @Test
    func extremeFiniteHalfTimeKeepsLoadingFinite() async throws {
        try await given {
            try TissueCompartment(
                halfTimes: .init(nitrogen: .init(.greatestFiniteMagnitude), helium: .init(5)),
                nitrogen: .init(0.7),
                helium: .init(0.2))
        } when: { initial in
            try initial.loaded(
                for: .init(10),
                nitrogenFrom: .init(1),
                nitrogenTo: .init(2),
                heliumFrom: .init(0.2),
                heliumTo: .init(0.2))
        } then: { _, loaded in
            #expect(loaded.nitrogen.value.isApproximately(0.7))
        }
    }

    @Test
    func extremeFiniteTensionsKeepLoadingFinite() async throws {
        try await given {
            try TissueCompartment(
                halfTimes: .init(nitrogen: .init(10), helium: .init(5)),
                nitrogen: .init(.greatestFiniteMagnitude),
                helium: .init(0))
        } when: { initial in
            try initial.loaded(
                for: .init(10),
                nitrogenFrom: .init(0),
                nitrogenTo: .init(.greatestFiniteMagnitude),
                heliumFrom: .init(0),
                heliumTo: .init(0))
        } then: { _, loaded in
            #expect((loaded.nitrogen.value / .greatestFiniteMagnitude).isApproximately(0.7786524795555183))
        }
    }

    @Test(.tags(.error))
    func halfTimesRejectZeroHalfTime() async throws {
        try await given {
            let halfTime = Minutes(0)
            let expectedError: Error = .range(.lowerBound(0, 0), "HalfTimes.init(nitrogen:helium:)")

            return (halfTime: halfTime, expectedError: expectedError)
        } when: { input in
            try expectThrowsError(
                when: try TissueCompartment.HalfTimes(nitrogen: input.halfTime, helium: .init(5)),
                then: input.expectedError) { error in
                #expect(error.localizationValue == "dive.kit.error.range.lower.bound")
            }
        }
    }

    @Test(.tags(.error))
    func halfTimesRejectInfiniteHalfTime() async throws {
        try await given {
            let halfTime = Minutes(.infinity)
            let expectedError: Error = .range(
                .upperBound(.infinity, .greatestFiniteMagnitude),
                "HalfTimes.init(nitrogen:helium:)")

            return (halfTime: halfTime, expectedError: expectedError)
        } when: { input in
            try expectThrowsError(
                when: try TissueCompartment.HalfTimes(nitrogen: .init(10), helium: input.halfTime),
                then: input.expectedError) { error in
                #expect(error.localizationValue == "dive.kit.error.range.upper.bound")
            }
        }
    }

    @Test(.tags(.error))
    func halfTimesRejectNaNHalfTime() async {
        await given {
            Minutes(.nan)
        } when: { halfTime in
            let error = #expect(throws: Error.self) {
                try TissueCompartment.HalfTimes(nitrogen: halfTime, helium: .init(5))
            }
            guard case let .range(.lowerBound(provided, _), _) = error else {
                Issue.record("Expected a lower-bound error, got \(String(describing: error)).")
                return
            }
            #expect(provided.isNaN)
        }
    }

    @Test(.tags(.error))
    func initializationRejectsNegativeNitrogenTension() async throws {
        try await given {
            let tension = -0.01
            let expectedError: Error = .negative(
                .partialPressure(tension),
                "TissueCompartment.init(halfTimes:nitrogen:helium:)")

            return (
                halfTimes: try TissueCompartment.HalfTimes(nitrogen: .init(10), helium: .init(5)),
                tension: tension,
                expectedError: expectedError)
        } when: { input in
            try expectThrowsError(
                when: try TissueCompartment(halfTimes: input.halfTimes, nitrogen: .init(input.tension), helium: .init(0.2)),
                then: input.expectedError) { error in
                #expect(error.localizationValue == "dive.kit.error.negative.partial.pressure")
            }
        }
    }

    @Test(.tags(.error))
    func initializationRejectsNegativeHeliumTension() async throws {
        try await given {
            let tension = -0.2
            let expectedError: Error = .negative(
                .partialPressure(tension),
                "TissueCompartment.init(halfTimes:nitrogen:helium:)")

            return (
                halfTimes: try TissueCompartment.HalfTimes(nitrogen: .init(10), helium: .init(5)),
                tension: tension,
                expectedError: expectedError)
        } when: { input in
            try expectThrowsError(
                when: try TissueCompartment(halfTimes: input.halfTimes, nitrogen: .init(0.7), helium: .init(input.tension)),
                then: input.expectedError) { error in
                #expect(error.localizationValue == "dive.kit.error.negative.partial.pressure")
            }
        }
    }

    @Test(.tags(.error))
    func constantLoadingRejectsInfiniteInspiredPressure() async throws {
        try await given {
            let expectedError: Error = .range(
                .upperBound(.infinity, .greatestFiniteMagnitude),
                "TissueCompartment.loaded(for:inspiredNitrogen:inspiredHelium:)")

            return (
                compartment: try TissueCompartment(
                    halfTimes: .init(nitrogen: .init(10), helium: .init(5)),
                    nitrogen: .init(0.7),
                    helium: .init(0.2)),
                pressure: PartialPressure<Nitrogen>(.infinity),
                expectedError: expectedError)
        } when: { input in
            try expectThrowsError(
                when: try input.compartment.loaded(
                    for: .init(5),
                    inspiredNitrogen: input.pressure,
                    inspiredHelium: .init(0.3)),
                then: input.expectedError) { error in
                #expect(error.localizationValue == "dive.kit.error.range.upper.bound")
            }
        }
    }

    @Test(.tags(.error))
    func linearLoadingRejectsNegativeInspiredPressure() async throws {
        try await given {
            let pressure = -0.3
            let expectedError: Error = .negative(
                .partialPressure(pressure),
                "TissueCompartment.loaded(for:nitrogenFrom:nitrogenTo:heliumFrom:heliumTo:)")

            return (
                compartment: try TissueCompartment(
                    halfTimes: .init(nitrogen: .init(10), helium: .init(5)),
                    nitrogen: .init(0.7),
                    helium: .init(0.2)),
                pressure: pressure,
                expectedError: expectedError)
        } when: { input in
            try expectThrowsError(
                when: try input.compartment.loaded(
                    for: .init(5),
                    nitrogenFrom: .init(1),
                    nitrogenTo: .init(1.5),
                    heliumFrom: .init(0.2),
                    heliumTo: .init(input.pressure)),
                then: input.expectedError) { error in
                #expect(error.localizationValue == "dive.kit.error.negative.partial.pressure")
            }
        }
    }

    @Test(.tags(.error))
    func loadingRejectsNegativeDuration() async throws {
        try await given {
            let duration = Minutes(-1)
            let expectedError: Error = .negative(
                .minutes(duration),
                "TissueCompartment.loaded(for:inspiredNitrogen:inspiredHelium:)")

            return (
                compartment: try TissueCompartment(
                    halfTimes: .init(nitrogen: .init(10), helium: .init(5)),
                    nitrogen: .init(0.7),
                    helium: .init(0.2)),
                duration: duration,
                expectedError: expectedError)
        } when: { input in
            try expectThrowsError(
                when: try input.compartment.loaded(
                    for: input.duration,
                    inspiredNitrogen: .init(1),
                    inspiredHelium: .init(0.3)),
                then: input.expectedError) { error in
                #expect(error.localizationValue == "dive.kit.error.negative.minutes")
            }
        }
    }
}
