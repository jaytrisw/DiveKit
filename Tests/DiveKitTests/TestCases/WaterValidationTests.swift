import Testing
@_spi(Experimental) @testable import DiveKit
import DiveKitTestSupport

@Suite("Water validation", .tags(.error))
struct WaterValidationTests {
    enum Operation: CaseIterable, Sendable {
        case gaugePressure
        case atmospheresAbsolute
        case pressureChange
        case airVolumeFromSurface
        case airVolumeToSurface
        case partialPressure
        case partialPressureInBlend
        case bestBlend
        case equivalentAirDepth
        case maximumOperatingDepth
        case equivalentNarcoticDepth
        case surfaceAirConsumption
        case respiratoryMinuteVolume

        var callSite: CallSite {
            switch self {
            case .gaugePressure: "PhysicsCalculator.gaugePressure(at:)"
            case .atmospheresAbsolute: "PhysicsCalculator.atmospheresAbsolute(at:)"
            case .pressureChange: "PhysicsCalculator.pressureChange(from:to:)"
            case .airVolumeFromSurface: "PhysicsCalculator.airVolumeFromSurface(to:with:)"
            case .airVolumeToSurface: "PhysicsCalculator.airVolumeToSurface(from:with:)"
            case .partialPressure: "GasCalculator.partialPressure(of:at:using:)"
            case .partialPressureInBlend: "GasCalculator.partialPressure(of:in:at:using:)"
            case .bestBlend: "GasCalculator.bestBlend(for:partialPressure:using:)"
            case .equivalentAirDepth: "GasCalculator.equivalentAirDepth(for:with:)"
            case .maximumOperatingDepth: "GasCalculator.maximumOperatingDepth(for:in:)"
            case .equivalentNarcoticDepth: "GasCalculator.equivalentNarcoticDepth(for:with:treating:)"
            case .surfaceAirConsumption: "GasCalculator.surfaceAirConsumption(at:for:start:end:using:)"
            case .respiratoryMinuteVolume: "GasCalculator.respiratoryMinuteVolume(at:for:consuming:with:using:)"
            }
        }

        func run(in water: Water) throws {
            let physics = PhysicsCalculator(.metric, water: water)
            switch self {
            case .gaugePressure, .atmospheresAbsolute, .pressureChange, .airVolumeFromSurface, .airVolumeToSurface:
                try runPhysics(physics)
            default:
                try runGas(GasCalculator(.metric, water: water), physics)
            }
        }

        private func runPhysics(_ physics: PhysicsCalculator) throws {
            switch self {
            case .gaugePressure: _ = try physics.gaugePressure(at: 30)
            case .atmospheresAbsolute: _ = try physics.atmospheresAbsolute(at: 30)
            case .pressureChange: _ = try physics.pressureChange(from: 10, to: 30)
            case .airVolumeFromSurface: _ = try physics.airVolumeFromSurface(to: 30, with: 10)
            default: _ = try physics.airVolumeToSurface(from: 30, with: 10)
            }
        }

        private func runGas(_ gas: GasCalculator, _ physics: PhysicsCalculator) throws {
            switch self {
            case .partialPressure:
                _ = try gas.partialPressure(of: FractionalPressure(of: .oxygen, fractionalPressure: 0.21), at: 30, using: physics)
            case .partialPressureInBlend: _ = try gas.partialPressure(of: Oxygen(), in: .air, at: 30, using: physics)
            case .bestBlend: _ = try gas.bestBlend(for: 30, partialPressure: 1.4, using: physics)
            case .equivalentAirDepth: _ = try gas.equivalentAirDepth(for: 30, with: .air)
            case .maximumOperatingDepth: _ = try gas.maximumOperatingDepth(for: 1.4, in: .air)
            case .equivalentNarcoticDepth: _ = try gas.equivalentNarcoticDepth(for: 30, with: .air)
            case .surfaceAirConsumption:
                _ = try gas.surfaceAirConsumption(at: 30, for: 10, start: 200, end: 150, using: physics)
            default:
                _ = try gas.respiratoryMinuteVolume(
                    at: 30,
                    for: 10,
                    consuming: 50,
                    with: Tank(blend: .air, size: .init(volume: 12, ratedPressure: 200, unit: .liters)),
                    using: physics)
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
            guard case let .range(.upperBound(provided, expected), callSite) = error else {
                Issue.record("Expected an upper-bound error, got \(String(describing: error)).")
                return
            }
            #expect(provided.isNaN)
            #expect(expected == .greatestFiniteMagnitude)
            #expect(callSite == operation.callSite)
            #expect(error?.localizationValue == "dive.kit.error.range.upper.bound")
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
