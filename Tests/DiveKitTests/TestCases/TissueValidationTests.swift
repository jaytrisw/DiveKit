import Testing
@_spi(Experimental) @testable import DiveKit

@Suite("Tissue validation", .tags(.technicalDiving, .error))
struct TissueValidationTests {
    @Test
    func componentRejectsMetabolicGas() async throws {
        try await given {
            let expectedError: Error = .gas(.metabolic(Oxygen()), "Component<Oxygen>.init(of:halfTime:tension:)")

            return (gas: Oxygen(), expectedError: expectedError)
        } when: { input in
            try expectThrowsError(
                when: try Tissue.Compartment.Component(of: input.gas, halfTime: .init(10), tension: .init(0.2)),
                then: input.expectedError) { error in
                #expect(error.localizationValue == "dive.kit.error.gas.metabolic")
            }
        }
    }

    @Test
    func componentRejectsZeroHalfTime() async throws {
        try await given {
            let halfTime = Minutes(0)
            let expectedError: Error = .range(.lowerBound(0, 0), "Component<Nitrogen>.init(of:halfTime:tension:)")

            return (halfTime: halfTime, expectedError: expectedError)
        } when: { input in
            try expectThrowsError(
                when: try Tissue.Compartment.Component(of: .nitrogen, halfTime: input.halfTime, tension: .init(0.7)),
                then: input.expectedError) { error in
                #expect(error.localizationValue == "dive.kit.error.range.lower.bound")
            }
        }
    }

    @Test
    func componentRejectsInfiniteHalfTime() async throws {
        try await given {
            let halfTime = Minutes(.infinity)
            let expectedError: Error = .range(
                .upperBound(.infinity, .greatestFiniteMagnitude),
                "Component<Helium>.init(of:halfTime:tension:)")

            return (halfTime: halfTime, expectedError: expectedError)
        } when: { input in
            try expectThrowsError(
                when: try Tissue.Compartment.Component(of: .helium, halfTime: input.halfTime, tension: .init(0.2)),
                then: input.expectedError) { error in
                #expect(error.localizationValue == "dive.kit.error.range.upper.bound")
            }
        }
    }

    @Test
    func componentRejectsNaNHalfTime() async {
        await given {
            Minutes(.nan)
        } when: { halfTime in
            let error = #expect(throws: Error.self) {
                try Tissue.Compartment.Component(of: .nitrogen, halfTime: halfTime, tension: .init(0.7))
            }
            guard case let .range(.lowerBound(provided, _), _) = error else {
                Issue.record("Expected a lower-bound error, got \(String(describing: error)).")
                return
            }
            #expect(provided.isNaN)
        }
    }

    @Test
    func componentRejectsNegativeTension() async throws {
        try await given {
            let tension = -0.01
            let expectedError: Error = .negative(
                .partialPressure(tension),
                "Component<Nitrogen>.init(of:halfTime:tension:)")

            return (tension: tension, expectedError: expectedError)
        } when: { input in
            try expectThrowsError(
                when: try Tissue.Compartment.Component(of: .nitrogen, halfTime: .init(10), tension: .init(input.tension)),
                then: input.expectedError) { error in
                #expect(error.localizationValue == "dive.kit.error.negative.partial.pressure")
            }
        }
    }

    @Test
    func constantInspiredRejectsInfinitePressure() async throws {
        try await given {
            let expectedError: Error = .range(
                .upperBound(.infinity, .greatestFiniteMagnitude),
                "Inspired<Nitrogen>.init(of:pressure:)")

            return (pressure: PartialPressure<Nitrogen>(.infinity), expectedError: expectedError)
        } when: { input in
            try expectThrowsError(
                when: try Tissue.Inspired(of: .nitrogen, pressure: input.pressure),
                then: input.expectedError) { error in
                #expect(error.localizationValue == "dive.kit.error.range.upper.bound")
            }
        }
    }

    @Test
    func linearInspiredRejectsNegativePressure() async throws {
        try await given {
            let pressure = -0.3
            let expectedError: Error = .negative(.partialPressure(pressure), "Inspired<Helium>.init(of:from:to:)")

            return (pressure: pressure, expectedError: expectedError)
        } when: { input in
            try expectThrowsError(
                when: try Tissue.Inspired(of: .helium, from: .init(0.2), to: .init(input.pressure)),
                then: input.expectedError) { error in
                #expect(error.localizationValue == "dive.kit.error.negative.partial.pressure")
            }
        }
    }
}
