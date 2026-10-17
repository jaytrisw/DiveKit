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

    enum BuoyancyOperation: CaseIterable, Sendable {
        case buoyancy
        case buoyancyOfObject
        case volumeOfObject

        var callSite: CallSite {
            switch self {
            case .buoyancy: "BuoyancyCalculator.buoyancy(of:)"
            case .buoyancyOfObject: "BuoyancyCalculator.buoyancyOfObject(weighing:andDisplacing:)"
            case .volumeOfObject: "BuoyancyCalculator.volumeOfObject(weighing:with:)"
            }
        }

        func run(in water: Water) throws {
            let calculator = BuoyancyCalculator(.metric, water: water)
            switch self {
            case .buoyancy:
                _ = try calculator.buoyancy(of: .init(weight: 100, volume: 100))
            case .buoyancyOfObject:
                _ = try calculator.buoyancyOfObject(weighing: 100, andDisplacing: 100)
            case .volumeOfObject:
                _ = try calculator.volumeOfObject(weighing: 100, with: .neutral)
            }
        }
    }

    @Test(arguments: [0.0, -1.0], BuoyancyOperation.allCases)
    func rejectsNonPositiveWaterWeight(weight: Double, operation: BuoyancyOperation) async throws {
        try await given {
            let expectedError: Error = .range(.lowerBound(weight, 0), operation.callSite)

            return (water: water(weight: weight), expectedError: expectedError)
        } when: { input in
            try expectThrowsError(
                when: try operation.run(in: input.water),
                then: input.expectedError) { error in
                #expect(error.localizationValue == "dive.kit.error.range.lower.bound")
            }
        }
    }

    @Test(arguments: [Double.infinity, -.infinity], BuoyancyOperation.allCases)
    func rejectsInfiniteWaterWeight(weight: Double, operation: BuoyancyOperation) async throws {
        try await given {
            let expectedError: Error = .range(.upperBound(weight, .greatestFiniteMagnitude), operation.callSite)

            return (water: water(weight: weight), expectedError: expectedError)
        } when: { input in
            try expectThrowsError(
                when: try operation.run(in: input.water),
                then: input.expectedError) { error in
                #expect(error.localizationValue == "dive.kit.error.range.upper.bound")
            }
        }
    }

    private func water(weight: Double) -> Water {
        .init(
            weight: { .init(weight, units: $0) },
            pressure: Water.salt.pressure)
    }
}
