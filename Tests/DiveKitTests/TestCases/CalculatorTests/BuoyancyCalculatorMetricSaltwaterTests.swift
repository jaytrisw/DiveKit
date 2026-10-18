import Testing
@testable import DiveKit
import DiveKitTestSupport

@Suite("Buoyancy Calculator", .tags(.buoyancyCalculator, .saltWater, .metric))
struct BuoyancyCalculatorMetricSaltwaterTests {

    // MARK: buoyancy(of:)

    /// 200 L × 1.025 kg/L − 209 kg = −4 kg.
    @Test
    func metricSaltwaterBuoyancyValidInput() async throws {
        let weight: Mass = 209
        let volume: Volume = 200
        let object: Object = .init(weight: weight, volume: volume)

        try await given {
            BuoyancyCalculator(.metric, water: .salt)
        } when: { sut in
            try sut.buoyancy(of: object)
        } then: { sut, calculation in
            guard case let .negative(force) = calculation.result else {
                Issue.record("Expected negative buoyancy, got \(calculation.result)")
                return
            }
            #expect(force.isApproximately(4))
            #expect(calculation.configuration == sut.configuration)
        }
    }

    /// 300 L × 1.025 kg/L − 307.5 kg = 0 kg, exact in binary floating point.
    @Test
    func metricSaltwaterBuoyancyValidInputNeutral() async throws {
        let weight: Mass = 307.5
        let volume: Volume = 300
        let object: Object = .init(weight: weight, volume: volume)

        try await given {
            BuoyancyCalculator(.metric, water: .salt)
        } when: { sut in
            try sut.buoyancy(of: object)
        } then: { sut, calculation in
            #expect(calculation.result == .neutral)
            #expect(calculation.configuration == sut.configuration)
        }
    }

    @Test(.tags(.error))
    func metricSaltwaterBuoyancyInvalidWeightInput() throws {
        let weight: Mass = -209
        let volume: Volume = 200
        let object: Object = .init(weight: weight, volume: volume)
        let expectedError = Error.negative(weight, "BuoyancyCalculator.buoyancy(of:)")
        let sut = BuoyancyCalculator(.metric, water: .salt)

        try expectThrowsError(
            when: sut.buoyancy(of: object),
            then: expectedError) {
                #expect($0.localizationValue == "dive.kit.error.negative.weight")
            }
    }

    @Test(.tags(.error))
    func metricSaltwaterBuoyancyInvalidVolumeInput() throws {
        let weight: Mass = 209
        let volume: Volume = -200
        let object: Object = .init(weight: weight, volume: volume)
        let expectedError = Error.negative(volume, "BuoyancyCalculator.buoyancy(of:)")
        let sut = BuoyancyCalculator(.metric, water: .salt)

        try expectThrowsError(
            when: sut.buoyancy(of: object),
            then: expectedError) {
                #expect($0.localizationValue == "dive.kit.error.negative.volume")
            }
    }

    // MARK: buoyancyOfObject(weighing:andDisplacing:)

    /// 50 L × 1.025 kg/L − 51 kg = 0.25 kg.
    @Test
    func metricSaltwaterBuoyancyOfObjectValidInput() async throws {
        let weight: Mass = 51
        let volume: Volume = 50

        try await given {
            BuoyancyCalculator(.metric, water: .salt)
        } when: { sut in
            try sut.buoyancyOfObject(weighing: weight, andDisplacing: volume)
        } then: { sut, calculation in
            guard case let .positive(force) = calculation.result else {
                Issue.record("Expected positive buoyancy, got \(calculation.result)")
                return
            }
            #expect(force.isApproximately(0.25))
            #expect(calculation.configuration == sut.configuration)
        }
    }

    @Test(.tags(.error))
    func metricSaltwaterBuoyancyOfObjectInvalidWeightInput() throws {
        let weight: Mass = -51
        let volume: Volume = 50
        let expectedError = Error.negative(weight, "BuoyancyCalculator.buoyancyOfObject(weighing:andDisplacing:)")
        let sut = BuoyancyCalculator(.metric, water: .salt)

        try expectThrowsError(
            when: sut.buoyancyOfObject(weighing: weight, andDisplacing: volume),
            then: expectedError) {
                #expect($0.localizationValue == "dive.kit.error.negative.weight")
            }
    }

    @Test(.tags(.error))
    func metricSaltwaterBuoyancyOfObjectInvalidVolumeInput() throws {
        let weight: Mass = 51
        let volume: Volume = -50
        let expectedError = Error.negative(volume, "BuoyancyCalculator.buoyancyOfObject(weighing:andDisplacing:)")
        let sut = BuoyancyCalculator(.metric, water: .salt)

        try expectThrowsError(
            when: sut.buoyancyOfObject(weighing: weight, andDisplacing: volume),
            then: expectedError) {
                #expect($0.localizationValue == "dive.kit.error.negative.volume")
            }
    }

    // MARK: volumeOfObject(weighing:with:)

    /// (75 kg − 20 kg) / 1.025 kg/L = 53.658536585365853… L.
    @Test
    func metricSaltwaterVolumeOfObjectWithValidInput() async throws {
        let weight: Mass = 75
        let buoyancy: Buoyancy = .negative(20)

        try await given {
            BuoyancyCalculator(.metric, water: .salt)
        } when: { sut in
            try sut.volumeOfObject(weighing: weight, with: buoyancy)
        } then: { sut, calculation in
            #expect(calculation.result.value.isApproximately(53.65853658536585))
            #expect(calculation.configuration == sut.configuration)
        }
    }

    @Test(.tags(.error))
    func metricSaltwaterVolumeOfObjectWithInvalidInput() throws {
        let weight: Mass = -75
        let buoyancy: Buoyancy = .negative(20)
        let expectedError = Error.negative(weight, "BuoyancyCalculator.volumeOfObject(weighing:with:)")
        let sut = BuoyancyCalculator(.metric, water: .salt)

        try expectThrowsError(
            when: sut.volumeOfObject(weighing: weight, with: buoyancy),
            then: expectedError) {
                #expect($0.localizationValue == "dive.kit.error.negative.weight")
            }
    }

    /// (75 kg + 20 kg) / 1.025 kg/L = 92.682926829268292… L.
    @Test
    func metricSaltwaterVolumeOfObjectAlternateWithValidInput() async throws {
        let weight: Mass = 75
        let buoyancy: Buoyancy = .positive(20)

        try await given {
            BuoyancyCalculator(.metric, water: .salt)
        } when: { sut in
            try sut.volumeOfObject(weighing: weight, with: buoyancy)
        } then: { sut, calculation in
            #expect(calculation.result.value.isApproximately(92.68292682926829))
            #expect(calculation.configuration == sut.configuration)
        }
    }

    @Test(.tags(.error))
    func metricSaltwaterVolumeOfObjectRejectsNonPositiveBuoyantForce() throws {
        let weight: Mass = 75
        let buoyancy: Buoyancy = .positive(-20)
        let expectedError = Error.range(
            .lowerBound(-20, 0),
            "BuoyancyCalculator.volumeOfObject(weighing:with:)")
        let sut = BuoyancyCalculator(.metric, water: .salt)

        try expectThrowsError(
            when: sut.volumeOfObject(weighing: weight, with: buoyancy),
            then: expectedError) {
                #expect($0.localizationValue == "dive.kit.error.range.lower.bound")
            }
    }

    @Test(.tags(.error))
    func metricSaltwaterVolumeOfObjectRejectsNegativeResultingVolume() throws {
        // (10.25 kg − 20.5 kg) / 1.025 kg/L = −10 L, exact in binary floating point.
        let weight: Mass = 10.25
        let buoyancy: Buoyancy = .negative(20.5)
        let expectedError = Error.negative(
            Volume(-10),
            "BuoyancyCalculator.volumeOfObject(weighing:with:)")
        let sut = BuoyancyCalculator(.metric, water: .salt)

        try expectThrowsError(
            when: sut.volumeOfObject(weighing: weight, with: buoyancy),
            then: expectedError) {
                #expect($0.localizationValue == "dive.kit.error.negative.volume")
            }
    }

    // MARK: Non-finite input

    enum NonFiniteInput: CaseIterable, Sendable {
        case buoyancyWeight
        case buoyancyVolume
        case buoyancyOfObjectWeight
        case buoyancyOfObjectVolume
        case volumeOfObjectWeight
        case volumeOfObjectBuoyantForce

        var callSite: CallSite {
            switch self {
                case .buoyancyWeight, .buoyancyVolume: "BuoyancyCalculator.buoyancy(of:)"
                case .buoyancyOfObjectWeight, .buoyancyOfObjectVolume: "BuoyancyCalculator.buoyancyOfObject(weighing:andDisplacing:)"
                case .volumeOfObjectWeight, .volumeOfObjectBuoyantForce: "BuoyancyCalculator.volumeOfObject(weighing:with:)"
            }
        }

        func run(with value: Double) throws {
            let sut = BuoyancyCalculator(.metric, water: .salt)
            switch self {
                case .buoyancyWeight: _ = try sut.buoyancy(of: .init(weight: .init(value), volume: 100))
                case .buoyancyVolume: _ = try sut.buoyancy(of: .init(weight: 100, volume: .init(value)))
                case .buoyancyOfObjectWeight: _ = try sut.buoyancyOfObject(weighing: .init(value), andDisplacing: 100)
                case .buoyancyOfObjectVolume: _ = try sut.buoyancyOfObject(weighing: 100, andDisplacing: .init(value))
                case .volumeOfObjectWeight: _ = try sut.volumeOfObject(weighing: .init(value), with: .neutral)
                case .volumeOfObjectBuoyantForce: _ = try sut.volumeOfObject(weighing: 75, with: .positive(value))
            }
        }
    }

    @Test(.tags(.error), arguments: NonFiniteInput.allCases, [Double.infinity, -.infinity])
    func metricSaltwaterRejectsInfiniteInput(input: NonFiniteInput, value: Double) async throws {
        try await given {
            let expectedError: Error = .range(.upperBound(value, .greatestFiniteMagnitude), input.callSite)
            return (input: input, value: value, expectedError: expectedError)
        } when: { input in
            Result { try input.input.run(with: input.value) }
        } then: { input, result in
            try expectThrowsError(when: result.get(), then: input.expectedError) {
                #expect($0.localizationValue == "dive.kit.error.range.upper.bound")
            }
        }
    }

    @Test(.tags(.error), arguments: NonFiniteInput.allCases)
    func metricSaltwaterRejectsNaNInput(input: NonFiniteInput) async throws {
        try await given {
            input
        } when: { input in
            expectThrowsNaNUpperBound(when: try input.run(with: .nan), callSite: input.callSite)
        }
    }

    @Test(.tags(.error))
    func metricSaltwaterBuoyancyRejectsOverflowingDisplacedWeight() async throws {
        try await given {
            let sut = BuoyancyCalculator(.metric, water: .salt)
            let object = Object(weight: 0, volume: .init(.greatestFiniteMagnitude))
            let expectedError: Error = .range(
                .upperBound(.infinity, .greatestFiniteMagnitude),
                "BuoyancyCalculator.buoyancy(of:)")
            return (sut: sut, object: object, expectedError: expectedError)
        } when: { input in
            Result { try input.sut.buoyancy(of: input.object) }
        } then: { input, result in
            try expectThrowsError(when: result.get(), then: input.expectedError) {
                #expect($0.localizationValue == "dive.kit.error.range.upper.bound")
            }
        }
    }

    @Test(.tags(.error))
    func metricSaltwaterVolumeOfObjectRejectsOverflowingResult() async throws {
        try await given {
            let sut = BuoyancyCalculator(.metric, water: .salt)
            let expectedError: Error = .range(
                .upperBound(.infinity, .greatestFiniteMagnitude),
                "BuoyancyCalculator.volumeOfObject(weighing:with:)")
            return (sut: sut, expectedError: expectedError)
        } when: { input in
            Result {
                try input.sut.volumeOfObject(
                    weighing: .init(.greatestFiniteMagnitude),
                    with: .positive(.greatestFiniteMagnitude))
            }
        } then: { input, result in
            try expectThrowsError(when: result.get(), then: input.expectedError) {
                #expect($0.localizationValue == "dive.kit.error.range.upper.bound")
            }
        }
    }
}
