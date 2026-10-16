import Testing
@_spi(Experimental) @testable import DiveKit

@Suite("Tissue loading", .tags(.technicalDiving))
struct TissueLoadingTests {
    @Test
    func haldaneMatchesSchreinerAtConstantPressure() async throws {
        try await given {
            try Tissue.Compartment(
                halfTimes: .init(nitrogen: .init(10), helium: .init(5)),
                nitrogen: .init(0.7),
                helium: .init(0.2))
        } when: { initial in
            (
                haldane: try initial.loaded(
                    for: .init(10),
                    inspiredNitrogen: .init(1.7),
                    inspiredHelium: .init(0.6),
                    using: .haldane),
                schreiner: try initial.loaded(
                    for: .init(10),
                    inspiredNitrogen: .init(1.7),
                    inspiredHelium: .init(0.6),
                    using: .schreiner))
        } then: { _, loaded in
            #expect(loaded.haldane.nitrogen.value.isApproximately(loaded.schreiner.nitrogen.value))
            #expect(loaded.haldane.helium.value.isApproximately(loaded.schreiner.helium.value))
        }
    }

    @Test
    func haldaneUsesMeanInspiredPressureDuringLinearChange() async throws {
        try await given {
            try Tissue.Compartment(
                halfTimes: .init(nitrogen: .init(10), helium: .init(5)),
                nitrogen: .init(0.7),
                helium: .init(0.2))
        } when: { initial in
            try initial.loaded(
                for: .init(10),
                nitrogenFrom: .init(1),
                nitrogenTo: .init(2),
                heliumFrom: .init(0.4),
                heliumTo: .init(0.1),
                using: .haldane)
        } then: { _, loaded in
            #expect(loaded.nitrogen.value.isApproximately(1.1))
            #expect(loaded.helium.value.isApproximately(0.2375))
        }
    }

    @Test
    func customModelReceivesEachGasSegment() async throws {
        try await given {
            try Tissue.Compartment(
                halfTimes: .init(nitrogen: .init(10), helium: .init(5)),
                nitrogen: .init(0.7),
                helium: .init(0.2))
        } when: { initial in
            try initial.loaded(
                for: .init(3),
                nitrogenFrom: .init(1),
                nitrogenTo: .init(2),
                heliumFrom: .init(0.4),
                heliumTo: .init(0.1),
                using: .init { tension, inspired, halfTime, duration in
                    tension + inspired.from + inspired.to + halfTime + duration
                })
        } then: { _, loaded in
            #expect(loaded.nitrogen.value.isApproximately(16.7))
            #expect(loaded.helium.value.isApproximately(8.7))
        }
    }

    @Test(.tags(.error))
    func loadingRejectsNegativeModelResult() async throws {
        try await given {
            let expectedError: Error = .negative(
                .partialPressure(-1),
                "Compartment.loaded(for:inspiredNitrogen:inspiredHelium:using:)")

            return (
                compartment: try Tissue.Compartment(
                    halfTimes: .init(nitrogen: .init(10), helium: .init(5)),
                    nitrogen: .init(0.7),
                    helium: .init(0.2)),
                model: Tissue.Loading { _, _, _, _ in -1 },
                expectedError: expectedError)
        } when: { input in
            try expectThrowsError(
                when: try input.compartment.loaded(
                    for: .init(5),
                    inspiredNitrogen: .init(1),
                    inspiredHelium: .init(0.3),
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
                "Compartment.loaded(for:inspiredNitrogen:inspiredHelium:using:)")

            return (
                compartment: try Tissue.Compartment(
                    halfTimes: .init(nitrogen: .init(10), helium: .init(5)),
                    nitrogen: .init(0.7),
                    helium: .init(0.2)),
                model: Tissue.Loading { _, _, _, _ in .infinity },
                expectedError: expectedError)
        } when: { input in
            try expectThrowsError(
                when: try input.compartment.loaded(
                    for: .init(5),
                    inspiredNitrogen: .init(1),
                    inspiredHelium: .init(0.3),
                    using: input.model),
                then: input.expectedError) { error in
                #expect(error.localizationValue == "dive.kit.error.range.upper.bound")
            }
        }
    }
}
