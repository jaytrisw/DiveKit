import Testing
@testable import DiveKit

@Suite("Buoyancy Calculator", .tags(.buoyancyCalculator, .saltWater, .metric))
struct BuoyancyCalculatorMetricSaltwaterTests {

    // MARK: buoyancy(of:)

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
            #expect(calculation.result == .negative(3))
            #expect(calculation.configuration == sut.configuration)
        }
    }

    @Test
    func metricSaltwaterBuoyancyValidInputNeutral() async throws {
        let weight: Mass = 309
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

    @Test
    func metricSaltwaterBuoyancyOfObjectValidInput() async throws {
        let weight: Mass = 51
        let volume: Volume = 50

        try await given {
            BuoyancyCalculator(.metric, water: .salt)
        } when: { sut in
            try sut.buoyancyOfObject(weighing: weight, andDisplacing: volume)
        } then: { sut, calculation in
            #expect(calculation.result == .positive(0.5))
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

    @Test
    func metricSaltwaterVolumeOfObjectWithValidInput() async throws {
        let weight: Mass = 75
        let buoyancy: Buoyancy = .negative(20)

        try await given {
            BuoyancyCalculator(.metric, water: .salt)
        } when: { sut in
            try sut.volumeOfObject(weighing: weight, with: buoyancy)
        } then: { sut, calculation in
            #expect(calculation.result.value.isApproximately(53.398058252427184))
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

    @Test
    func metricSaltwaterVolumeOfObjectAlternateWithValidInput() async throws {
        let weight: Mass = 75
        let buoyancy: Buoyancy = .positive(20)

        try await given {
            BuoyancyCalculator(.metric, water: .salt)
        } when: { sut in
            try sut.volumeOfObject(weighing: weight, with: buoyancy)
        } then: { sut, calculation in
            #expect(calculation.result.value.isApproximately(92.23300970873787))
            #expect(calculation.configuration == sut.configuration)
        }
    }
}
