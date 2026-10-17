import Testing
@_spi(Experimental) @testable import DiveKit

@Suite("Water validation", .tags(.error))
struct WaterValidationTests {
    enum Operation: CaseIterable, Sendable {
        case gaugePressure
        case atmospheresAbsolute
        case equivalentAirDepth
        case maximumOperatingDepth
        case equivalentNarcoticDepth

        var callSite: CallSite {
            switch self {
            case .gaugePressure: "PhysicsCalculator.gaugePressure(at:)"
            case .atmospheresAbsolute: "PhysicsCalculator.atmospheresAbsolute(at:)"
            case .equivalentAirDepth: "GasCalculator.equivalentAirDepth(for:with:)"
            case .maximumOperatingDepth: "GasCalculator.maximumOperatingDepth(for:in:)"
            case .equivalentNarcoticDepth: "GasCalculator.equivalentNarcoticDepth(for:with:treating:)"
            }
        }

        func run(in water: Water) throws {
            switch self {
            case .gaugePressure:
                _ = try PhysicsCalculator(.metric, water: water).gaugePressure(at: 30)
            case .atmospheresAbsolute:
                _ = try PhysicsCalculator(.metric, water: water).atmospheresAbsolute(at: 30)
            case .equivalentAirDepth:
                _ = try GasCalculator(.metric, water: water).equivalentAirDepth(for: 30, with: .air)
            case .maximumOperatingDepth:
                _ = try GasCalculator(.metric, water: water).maximumOperatingDepth(for: 1.4, in: .air)
            case .equivalentNarcoticDepth:
                _ = try GasCalculator(.metric, water: water).equivalentNarcoticDepth(for: 30, with: .air)
            }
        }
    }

    @Test(arguments: [0.0, -10.0], Operation.allCases)
    func rejectsNonPositiveIncrease(increase: Double, operation: Operation) async throws {
        try await given {
            let expectedError: Error = .range(.lowerBound(increase, 0), operation.callSite)

            return (water: water(increase: increase), expectedError: expectedError)
        } when: { input in
            try expectThrowsError(
                when: try operation.run(in: input.water),
                then: input.expectedError) { error in
                #expect(error.localizationValue == "dive.kit.error.range.lower.bound")
            }
        }
    }

    @Test(arguments: [Double.infinity, -.infinity], Operation.allCases)
    func rejectsInfiniteIncrease(increase: Double, operation: Operation) async throws {
        try await given {
            let expectedError: Error = .range(.upperBound(increase, .greatestFiniteMagnitude), operation.callSite)

            return (water: water(increase: increase), expectedError: expectedError)
        } when: { input in
            try expectThrowsError(
                when: try operation.run(in: input.water),
                then: input.expectedError) { error in
                #expect(error.localizationValue == "dive.kit.error.range.upper.bound")
            }
        }
    }

    @Test(arguments: Operation.allCases)
    func rejectsNaNIncrease(operation: Operation) async {
        await given {
            water(increase: .nan)
        } when: { water in
            let error = #expect(throws: Error.self) {
                try operation.run(in: water)
            }
            guard case let .range(.upperBound(provided, _), callSite) = error else {
                Issue.record("Expected an upper-bound error, got \(String(describing: error)).")
                return
            }
            #expect(provided.isNaN)
            #expect(callSite == operation.callSite)
        }
    }

    private func water(increase: Double) -> Water {
        .init(
            weight: Water.salt.weight,
            pressure: { .init(increase: .init(increase, units: $0)) })
    }
}
