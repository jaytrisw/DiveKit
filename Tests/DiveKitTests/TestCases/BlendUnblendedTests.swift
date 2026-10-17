import Testing
@testable import DiveKit

@Suite("Blend Unblended", .tags(.blend))
struct BlendUnblendedTests {
    @Test
    func addWithValidInput() throws {
        var sut = Blend<Unblended>()
        let oxygenFraction = 0.8
        let fractionalPressure = try FractionalPressure(of: .oxygen, fractionalPressure: oxygenFraction)

        try sut.add(fractionalPressure)

        #expect(sut.components().count == 1)
        #expect(sut.fractionalPressure(of: .oxygen) == oxygenFraction)
    }

    @Test(.tags(.error), arguments: [-0.8, 1.01])
    func addWithInvalidInput_consumingUnsafeAPI(oxygenFraction: Double) throws {
        var sut = Blend<Unblended>()
        let fractionalPressure = FractionalPressure(.oxygen, fractionalPressure: oxygenFraction)
        let expectedError = Error.blend(.pressureRange(oxygenFraction, sut), "Blend<Unblended>.add(_:)")

        try expectThrowsError(
            when: sut.add(fractionalPressure),
            then: expectedError) {
                #expect($0.localizationValue == "dive.kit.error.blend.pressure.range")
            }
    }

    @Test
    func addingWithValidInput() throws {
        let sut = Blend<Unblended>()
        let oxygenFraction = 0.8
        let fractionalPressure = try FractionalPressure(of: .oxygen, fractionalPressure: oxygenFraction)

        let result = try sut.adding(fractionalPressure)

        #expect(result.components().count == 1)
        #expect(result.fractionalPressure(of: .oxygen) == oxygenFraction)
    }

    @Test
    func updateWithValidInput() throws {
        var sut = Blend<Unblended>()
        let initialOxygenFraction = 0.8
        let updatedOxygenFraction = 0.4
        try sut.add(.oxygen, pressure: initialOxygenFraction)

        try sut.update(.oxygen, pressure: updatedOxygenFraction)

        #expect(sut.components().count == 1)
        #expect(sut.fractionalPressure(of: .oxygen) == updatedOxygenFraction)
    }

    @Test
    func updateWithFractionalPressure() throws {
        var sut = Blend<Unblended>()
        let initialOxygenFraction = 0.8
        let updatedOxygenFraction = 0.4
        let fractionalPressure = try FractionalPressure(of: .oxygen, fractionalPressure: updatedOxygenFraction)
        try sut.add(.oxygen, pressure: initialOxygenFraction)

        try sut.update(fractionalPressure)

        #expect(sut.components().count == 1)
        #expect(sut.fractionalPressure(of: .oxygen) == updatedOxygenFraction)
    }

    @Test(.tags(.error))
    func updateWithInvalidInput() throws {
        var sut = Blend<Unblended>()
        let oxygenFraction = 1.01
        let expectedError = Error.blend(.pressureRange(oxygenFraction, sut), "Blend<Unblended>.update(_:pressure:)")

        try expectThrowsError(
            when: sut.update(.oxygen, pressure: oxygenFraction),
            then: expectedError) {
                #expect($0.localizationValue == "dive.kit.error.blend.pressure.range")
            }
    }

    @Test
    func updatingWithValidInput() throws {
        var sut = Blend<Unblended>()
        let initialOxygenFraction = 0.8
        let updatedOxygenFraction = 0.4
        try sut.add(.oxygen, pressure: initialOxygenFraction)

        let result = try sut.updating(.oxygen, pressure: updatedOxygenFraction)

        #expect(sut.fractionalPressure(of: .oxygen) == initialOxygenFraction)
        #expect(result.components().count == 1)
        #expect(result.fractionalPressure(of: .oxygen) == updatedOxygenFraction)
    }

    @Test
    func updatingWithFractionalPressure() throws {
        var sut = Blend<Unblended>()
        let initialOxygenFraction = 0.8
        let updatedOxygenFraction = 0.4
        let fractionalPressure = try FractionalPressure(of: .oxygen, fractionalPressure: updatedOxygenFraction)
        try sut.add(.oxygen, pressure: initialOxygenFraction)

        let result = try sut.updating(fractionalPressure)

        #expect(sut.fractionalPressure(of: .oxygen) == initialOxygenFraction)
        #expect(result.components().count == 1)
        #expect(result.fractionalPressure(of: .oxygen) == updatedOxygenFraction)
    }

    @Test
    func fillWithValidInput() throws {
        var sut = Blend<Unblended>()

        try sut.fill(with: Oxygen())

        #expect(sut.components().count == 1)
        #expect(sut.fractionalPressure(of: .oxygen) == 1)
    }

    @Test
    func fillingWithValidInput() throws {
        let sut = Blend<Unblended>()

        let result = try sut.filling(with: Oxygen())

        #expect(result.components().count == 1)
        #expect(result.fractionalPressure(of: .oxygen) == 1)
        #expect(result.components().first.forceUnwrap().isEqual(to: .oxygen))
    }

    @Test
    func blendWithValidInput() throws {
        var sut = Blend<Unblended>()
        try sut.fill(with: Oxygen())

        let result = try sut.blend()

        #expect(result.components().count == 1)
        #expect(try result.fractionalPressure(of: .oxygen).value == 1)
    }

    @Test(.tags(.error))
    func blendWithInvalidInput() throws {
        var sut = Blend<Unblended>()
        let oxygenFraction = 0.1
        try sut.add(.oxygen, pressure: oxygenFraction)
        let expectedError = Error.blend(.totalPressure(oxygenFraction, sut), "Blend<Unblended>.blend()")

        try expectThrowsError(
            when: sut.blend(),
            then: expectedError) {
                #expect($0.localizationValue == "dive.kit.error.blend.total.pressure")
            }
    }

    @Test
    func initializeWithFractionalPressures() throws {
        let oxygen = try FractionalPressure(of: .oxygen, fractionalPressure: 0.40)
        let nitrogen = try FractionalPressure(of: .nitrogen, fractionalPressure: 0.60)
        let sut = Blend<Unblended>(oxygen, nitrogen)

        let result = try sut.blend()

        #expect(try result.fractionalPressure(of: .oxygen) == oxygen)
        #expect(try result.fractionalPressure(of: .nitrogen) == nitrogen)
        #expect(result.totalPressure == 1.0)
        #expect(result.components().count == 2)
    }

    @Test
    func initializeWithResultBuilder() throws {
        let sut = try Blend<Unblended> { () throws(DiveKit.Error) in
            try FractionalPressure(of: .oxygen, fractionalPressure: 0.40)

            try FractionalPressure(of: .nitrogen, fractionalPressure: 0.60)
        }

        #expect(sut.totalPressure == 1.0)
        #expect(sut.components().count == 2)
    }

    @Test
    func initializeWithResultBuilder_consumingUnsafeAPI() {
        let oxygen = FractionalPressure(.oxygen, fractionalPressure: 0.40)
        let nitrogen = FractionalPressure(.nitrogen, fractionalPressure: 0.60)

        let sut = Blend<Unblended> {
            oxygen

            nitrogen
        }

        #expect(sut.totalPressure == 1.0)
        #expect(sut.components().count == 2)
    }

    enum Mutation: CaseIterable, Sendable {
        case add
        case addFractionalPressure
        case update
        case updateFractionalPressure
        case adding
        case addingFractionalPressure
        case updating
        case updatingFractionalPressure

        var callSite: CallSite {
            switch self {
                case .add: "Blend<Unblended>.add(_:pressure:)"
                case .addFractionalPressure: "Blend<Unblended>.add(_:)"
                case .update: "Blend<Unblended>.update(_:pressure:)"
                case .updateFractionalPressure: "Blend<Unblended>.update(_:)"
                case .adding: "Blend<Unblended>.adding(_:pressure:)"
                case .addingFractionalPressure: "Blend<Unblended>.adding(_:)"
                case .updating: "Blend<Unblended>.updating(_:pressure:)"
                case .updatingFractionalPressure: "Blend<Unblended>.updating(_:)"
            }
        }

        func run(on blend: Blend<Unblended>, pressure: Double) throws {
            var blend = blend
            let fractionalPressure = FractionalPressure(.oxygen, fractionalPressure: pressure)
            switch self {
                case .add: try blend.add(.oxygen, pressure: pressure)
                case .addFractionalPressure: try blend.add(fractionalPressure)
                case .update: try blend.update(.oxygen, pressure: pressure)
                case .updateFractionalPressure: try blend.update(fractionalPressure)
                case .adding: _ = try blend.adding(.oxygen, pressure: pressure)
                case .addingFractionalPressure: _ = try blend.adding(fractionalPressure)
                case .updating: _ = try blend.updating(.oxygen, pressure: pressure)
                case .updatingFractionalPressure: _ = try blend.updating(fractionalPressure)
            }
        }
    }

    @Test(.tags(.error), arguments: Mutation.allCases, [-0.8, 1.01])
    func mutationReportsItsOwnCallSite(mutation: Mutation, pressure: Double) async throws {
        try await given {
            let blend = Blend<Unblended>()
            let expectedError = Error.blend(.pressureRange(pressure, blend), mutation.callSite)
            return (blend: blend, expectedError: expectedError)
        } when: { input in
            try expectThrowsError(
                when: try mutation.run(on: input.blend, pressure: pressure),
                then: input.expectedError) {
                    #expect($0.localizationValue == "dive.kit.error.blend.pressure.range")
                }
        }
    }

    enum Fill: CaseIterable, Sendable {
        case fill
        case filling

        var callSite: CallSite {
            switch self {
                case .fill: "Blend<Unblended>.fill(with:)"
                case .filling: "Blend<Unblended>.filling(with:)"
            }
        }

        func run(on blend: Blend<Unblended>) throws {
            var blend = blend
            switch self {
                case .fill: try blend.fill(with: Nitrogen())
                case .filling: _ = try blend.filling(with: Nitrogen())
            }
        }
    }

    @Test(.tags(.error), arguments: Fill.allCases)
    func fillRejectsOverfullBlend(fill: Fill) async throws {
        try await given {
            let blend = try Blend<Unblended>()
                .adding(.oxygen, pressure: 0.8)
                .adding(.nitrogen, pressure: 0.8)
            let expectedError = Error.blend(.pressureRange(1 - blend.totalPressure, blend), fill.callSite)
            return (blend: blend, expectedError: expectedError)
        } when: { input in
            try expectThrowsError(
                when: try fill.run(on: input.blend),
                then: input.expectedError) {
                    #expect($0.localizationValue == "dive.kit.error.blend.pressure.range")
                }
        }
    }
}
